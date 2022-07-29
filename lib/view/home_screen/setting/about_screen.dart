import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../common/text.dart';
import '../../../controller/info_controller.dart';

class About extends StatefulWidget {
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  List aboutList = [
    'Available',
    'Busy',
    'At school',
    'At the movies',
    'At work',
    'Battery about to die',
    'Can\'t talk,Whatsapp only',
    'At the gym',
    'Sleeping'
  ];

  var selected = -1;

  InfoController infoController = Get.put(InfoController());

  final TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    _bio.text = infoController.bio!;
    infoController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Ts(text: "About ", size: height * 0.025),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: GetBuilder<InfoController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.026,
                ),
                Ts(
                  text: "Currently set to",
                  size: 16,
                  color: Colors.grey,
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ts(
                        text: "${controller.bio}",
                        size: height * 0.022,
                        weight: FontWeight.w400),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actionsPadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.zero,
                                buttonPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                actionsAlignment: MainAxisAlignment.start,
                                content: Container(
                                    width: width,
                                    height: height * 0.2,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.08),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height * 0.03,
                                              ),
                                              Ts(
                                                text: "Add About",
                                                size: 17,
                                                weight: FontWeight.w500,
                                              ),
                                              TextFormField(
                                                controller: _bio,
                                                decoration: InputDecoration(
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.mainColor
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.016,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.03),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Ts(
                                                    text: "CANCEL",
                                                    color: Colors.grey,
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    controller
                                                        .updateBio(_bio.text);
                                                    controller.getUserData();
                                                    Get.back();
                                                  },
                                                  child: Ts(
                                                    text: "SAVE",
                                                    color: Colors.grey,
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.mainColor,
                        ))
                  ],
                ),
                SizedBox(
                  height: height * 0.007,
                ),
                Divider(
                  thickness: 0.5,
                ),
                SizedBox(
                  height: height * 0.007,
                ),
                Ts(
                  text: 'Select About',
                  size: 16,
                  color: Colors.grey,
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: height * 0.007,
                ),
                ...List.generate(
                  aboutList.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.018),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
                          _bio.text = aboutList[index];
                          controller.updateBio(aboutList[index]);
                          controller.getUserData();
                        });
                      },
                      child: SizedBox(
                        height: height * 0.025,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Ts(
                              text: "${aboutList[index]}",
                              size: height * 0.022,
                            ),
                            selected == index
                                ? Icon(
                                    Icons.check,
                                    color: AppColors.mainColor,
                                  )
                                : Icon(
                                    Icons.check,
                                    color: Colors.transparent,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
