import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/mobile_auth_controller.dart';
import '../common/button.dart';
import '../common/colors.dart';
import '../common/text.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  MobileController mobileController = Get.put(MobileController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Ts(
          text: "Enter OTP",
          color: AppColors.mainColor,
          size: height * 0.025,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<MobileController>(
        builder: (controller) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Ts(
                  text: 'whatsApp sent verification code.',
                  size: height * 0.017,
                ),
                SizedBox(
                  height: height * 0.05,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: Container(
                    height: height * 0.06,
                    width: width,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textColor)),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: controller.otp,
                          decoration: InputDecoration(
                            counter: Offstage(),
                            border: InputBorder.none,
                            hintText: 'O T P',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),

                /// send otp
                controller.isLoading == false
                    ? Button(
                        buttonName: 'NEXT',
                        onTap: () {
                          if (controller.phone.text.length < 6) {
                            showAlert('Enter 6 digit OTP');
                          } else {
                            controller.verifyOtp(context);
                          }
                        },
                        buttonColor: AppColors.mainColor,
                        height: height * 0.045,
                        width: height * 0.11,
                        fontSize: height * 0.018,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                SizedBox(
                  height: height * 0.03,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
