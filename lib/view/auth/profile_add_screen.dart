import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/mobile_auth_controller.dart';
import 'package:whatsapp/view/home_screen/home_screen.dart';
import '../common/button.dart';
import '../common/colors.dart';
import '../common/image_upload.dart';
import '../common/text.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class AddInfoScreen extends StatefulWidget {
  const AddInfoScreen({Key? key}) : super(key: key);

  @override
  State<AddInfoScreen> createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends State<AddInfoScreen> {
  TextEditingController name = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());

  File? userImage;
  final picker = ImagePicker();

  pickImage() async {
    var filePick = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      userImage = File(filePick!.path);
    });
  }

  var image;
  void getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    Map<String, dynamic>? getUserData = user.data();
    setState(() {
      print('>>>> $image');
      image = getUserData?['image'];
      name.text = getUserData?['name'];
    });
  }

  initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Ts(
          text: "Personal Info",
          color: AppColors.mainColor,
          size: height * 0.025,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            GestureDetector(
              onTap: () {
                pickImage();
                image = null;
              },
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: height * 0.15,
                width: height * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textColor.withAlpha(100),
                ),
                child: image != null
                    ? Image.network(
                        '$image',
                        fit: BoxFit.cover,
                      )
                    : userImage == null
                        ? Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: height * 0.04,
                            ),
                          )
                        : Image.file(
                            userImage!,
                            fit: BoxFit.cover,
                          ),
              ),
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
                      textInputAction: TextInputAction.done,
                      controller: name,
                      decoration: InputDecoration(
                        counter: Offstage(),
                        border: InputBorder.none,
                        hintText: 'Enter Number',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Obx(
              () => profileController.isNext.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Button(
                      buttonName: 'NEXT',
                      onTap: () async {
                        if (name.text.isNotEmpty) {
                          profileController.isNexted();
                          var profileUrl = image ??
                              await uploadFile(
                                  file: userImage!,
                                  filename: '${Random().nextInt(100000)}.png');
                          print('URLLLL$profileUrl');
                          storage.write('name', name.text);

                          firebaseFirestore
                              .collection('user')
                              .doc(firebaseAuth.currentUser!.uid)
                              .set({
                            'number': '${storage.read('mobile')}',
                            'token': storage.read('token'),
                            'name': name.text,
                            'image': profileUrl,
                            'status': 'Offline',
                            'bio': 'Available',
                            'time': DateTime.now(),
                            'roomId': '0'
                          }).catchError((e) {
                            showAlert('Try Again');
                            profileController.isNotNexted();
                          });
                          storage.write('userImage', profileUrl);
                          Get.offAll(() => HomeScreen(),
                              transition: Transition.leftToRight);
                          profileController.isNotNexted();
                        } else {
                          showAlert('Enter Name');
                          profileController.isNotNexted();
                        }
                      },
                      buttonColor: AppColors.mainColor,
                      height: height * 0.045,
                      width: height * 0.11,
                      fontSize: height * 0.018,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
