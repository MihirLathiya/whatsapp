import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:whatsapp/view/common/colors.dart';
import 'package:whatsapp/view/home_screen/home_screen.dart';
import '../view/auth/otp_screen.dart';
import '../view/auth/profile_add_screen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class MobileController extends GetxController {
  final TextEditingController phone = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final TextEditingController name = TextEditingController();
  String verificationIds = "";
  bool isLoading = false;
  bool isLoading1 = false;

  sendOtp(BuildContext context) async {
    isLoading = true;
    update();
    try {
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91" + phone.text,
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            showAlert("Otp send");
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            verificationIds = verificationId;
            Get.to(() => OtpScreen(), transition: Transition.leftToRight);

            isLoading = false;

            update();
          },
          verificationFailed: (FirebaseAuthException e) {
            isLoading = false;
            update();
            if (e.code == 'invalid-phone-number') {
              showAlert('Invalid MobileNumber');
              print('Invalid MobileNumber');
            } else if (e.code == 'missing-phone-number') {
              showAlert('Missing Phone Number');
            } else if (e.code == 'user-disabled') {
              showAlert('Number is Disabled');
              print('Number is Disabled');
            } else if (e.code == 'quota-exceeded') {
              showAlert('You try too many time. try later ');
            } else if (e.code == 'captcha-check-failed') {
              showAlert('Try Again');
            } else {
              showAlert('Verification Failed!');
            }
            print('>>> Verification Failed');
          });
    } on FirebaseAuthException catch (e) {
      print('$e');
    }
  }

  ///Verify Otp
  verifyOtp(BuildContext context) async {
    try {
      isLoading = true;
      update();
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationIds, smsCode: otp.text);

      String? token = await FirebaseMessaging.instance.getToken();
      print('Fcm Token : $token');

      firebaseAuth.signInWithCredential(phoneAuthCredential).catchError((e) {
        isLoading = false;
        update();
        if (e.code == 'expired-action-code') {
          showAlert('Code Expired');
        } else if (e.code == 'invalid-action-code') {
          showAlert('Invalid Code');
        } else if (e.code == 'user-disabled') {
          showAlert('User Disabled');
        }
      }).then((value) {
        if (phoneAuthCredential.verificationId!.isEmpty) {
          isLoading = false;
          update();
          showAlert("Enter Valid OTP");
        } else {
          storage.write("mobile", phone.text);
          storage.write('token', token);
          Get.off(() => AddInfoScreen(), transition: Transition.leftToRight);
          isLoading = false;
          update();
        }
      });
    } on FirebaseAuthException catch (e) {
    } catch (e) {
      isLoading = false;
      update();
      print(e.toString());
    }
  }

  /// enter Name

}

class ProfileController extends GetxController {
  var isNext = false.obs;

  var userImage;

  isNexted() {
    isNext.value = true;
  }

  isNotNexted() {
    isNext.value = false;
  }

  isChange(fileImage) {
    userImage = fileImage;
    update();
  }
}

void showAlert(String? msg) {
  Fluttertoast.showToast(msg: msg!);
}
