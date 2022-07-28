import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/view/common/colors.dart';
import 'package:whatsapp/view/home_screen/profile_screen.dart';
import '../../controller/info_controller.dart';
import '../common/text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final InfoController _infoController = Get.put(InfoController());
  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Ts(text: "Settings", size: 20),
          backgroundColor: AppColors.mainColor),
      body: GetBuilder<InfoController>(
        builder: (controller) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(Profile(), transition: Transition.leftToRight);
                },
                child: SizedBox(
                  height: height * 0.1,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Hero(
                              tag: '${controller.Img}',
                              child: Container(
                                height: height * 0.075,
                                width: height * 0.075,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    '${controller.Img}',
                                    height: height * 0.075,
                                    width: height * 0.075,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.03500,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Ts(
                                  text:
                                      "${controller.name ?? storage.read('name')}",
                                  size: height * 0.023,
                                  weight: FontWeight.w400,
                                ),
                                SizedBox(height: height * 0.0025),
                                Ts(
                                  text: "${controller.bio}",
                                  color: Colors.grey,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 0.07,
                color: Colors.grey,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.key,
                            color: Colors.grey,
                            size: height * 0.026,
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ts(
                          text: "Account",
                          size: height * 0.019,
                        ),
                        SizedBox(
                          height: height * 0.0025,
                        ),
                        Ts(
                          text: "Privacy, security, change number",
                          color: Colors.grey,
                          size: height * 0.017,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: Icon(
                        Icons.message,
                        color: Colors.grey,
                        size: height * 0.026,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ts(
                          text: "Chats",
                          size: height * 0.019,
                        ),
                        SizedBox(
                          height: height * 0.0025,
                        ),
                        Ts(
                          text: "Theme, wallpapers, chat history",
                          color: Colors.grey,
                          size: height * 0.017,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.036,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.grey,
                        size: height * 0.026,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ts(
                          text: "Notifications",
                          size: height * 0.019,
                        ),
                        SizedBox(
                          height: height * 0.0025,
                        ),
                        Ts(
                          text: "Message, group & call tones",
                          color: Colors.grey,
                          size: height * 0.017,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.036,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: Icon(
                        Icons.data_usage,
                        color: Colors.grey,
                        size: height * 0.026,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ts(
                          text: "Storage and data",
                          size: height * 0.019,
                        ),
                        SizedBox(
                          height: height * 0.0025,
                        ),
                        Ts(
                          text: "Network usage, auto-download",
                          color: Colors.grey,
                          size: height * 0.017,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.036,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: Icon(
                        Icons.language,
                        color: Colors.grey,
                        size: height * 0.026,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ts(
                          text: "App language",
                          size: height * 0.019,
                        ),
                        SizedBox(
                          height: height * 0.0025,
                        ),
                        Ts(
                          text: "English (phone's language)",
                          color: Colors.grey,
                          size: height * 0.017,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.036,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: Icon(
                        Icons.help_outline_outlined,
                        color: Colors.grey,
                        size: height * 0.026,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ts(
                          text: "Help",
                          size: height * 0.019,
                        ),
                        SizedBox(
                          height: height * 0.0025,
                        ),
                        Ts(
                          text: "Help centre, contact us, privacy policy",
                          color: Colors.grey,
                          size: height * 0.017,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.036,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                    child: Icon(
                      Icons.people,
                      color: Colors.grey,
                      size: height * 0.026,
                    ),
                  ),
                  Ts(
                    text: "Invite a friend",
                    size: height * 0.019,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
