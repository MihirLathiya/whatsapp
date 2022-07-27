import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/view/home_screen/status/status_add_screen.dart';
import 'package:whatsapp/view/home_screen/status/status_view_screen.dart';
import '../../common/colors.dart';
import '../../common/text.dart';

class Status extends StatefulWidget {
  final userName, userImage;
  const Status({Key? key, this.userName, this.userImage}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  File? userImage;
  final picker = ImagePicker();

  pickImage() async {
    var filePick = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      userImage = File(filePick!.path);
      Get.to(
          () => StatusAdd(
                status: userImage,
              ),
          transition: Transition.leftToRight);
    });
  }

  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print('USERSTATUSImage :- ${userImage}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            pickImage();
          },
          child: Container(
            height: height * 0.09,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: height * 0.06,
                      width: height * 0.06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textColor.withAlpha(100),
                      ),
                      child: Image.network(
                        '${widget.userImage}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -width * 0.005,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.white,
                        child: Center(
                          child: Icon(
                            Icons.add_circle,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: width * 0.06,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Ts(
                      text: 'My Status',
                      size: height * 0.02,
                      weight: FontWeight.w700,
                    ),
                    Ts(
                      text: 'Tap to update Status',
                      size: height * 0.015,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .08),
          child: Ts(
            text: 'Recent Update',
            weight: FontWeight.w700,
            size: height * 0.014,
          ),
        ),
        StreamBuilder(
          stream: firebaseFirestore.collection('status').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var userStatus = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () async {
                        Get.to(
                          () => StatusView(
                            comment: userStatus['StatusMessage'],
                            status: userStatus['image'],
                          ),
                        );
                        setState(() {
                          isShow = true;
                        });
                      },
                      child: Container(
                        height: height * 0.09,
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: height * 0.033,
                              backgroundColor: isShow == true
                                  ? AppColors.textColor
                                  : AppColors.mainColor,
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: height * 0.06,
                                width: height * 0.06,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.textColor.withAlpha(100),
                                ),
                                child: Hero(
                                  tag: '${userStatus['image']}',
                                  child: Image.network(
                                    '${userStatus['image']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.06,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Ts(
                                  text: '${userStatus['name']}',
                                  size: height * 0.02,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox();
            }
          },
        )
      ],
    );
  }
}
