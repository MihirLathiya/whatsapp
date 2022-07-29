import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/view/home_screen/home_screen.dart';
import 'package:whatsapp/view/prefrence_manager.dart';

import '../../../common/colors.dart';
import '../../../common/image_upload.dart';
import '../../../controller/controllers.dart';

class StatusAdd extends StatefulWidget {
  final status;
  const StatusAdd({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  State<StatusAdd> createState() => _StatusAddState();
}

class _StatusAddState extends State<StatusAdd> {
  TextEditingController statusMessage = TextEditingController();
  StatusController statusController = Get.put(StatusController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.file(
                widget.status,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.015),
            child: Row(
              children: [
                Container(
                  height: height * 0.06,
                  width: width * 0.82,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.82,
                    child: TextFormField(
                      controller: statusMessage,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () {},
                            splashRadius: 10,
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                            )),
                        hintText: "Message",
                        hintTextDirection: TextDirection.ltr,
                        hintStyle: TextStyle(fontSize: 18),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Obx(
                  () => statusController.isLoading.value == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GestureDetector(
                          onTap: () {
                            statusController.isLoaded();
                            if (statusController.isLoading.value == true) {
                              uploadStatus();
                            } else {
                              statusController.isNotLoaded();
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.mainColor,
                            radius: height * 0.027,
                            child: Icon(
                              Icons.send,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void uploadStatus() async {
    String? url = await uploadFile(
        file: widget.status, filename: '${Random().nextInt(12345689)}');
    firebaseFirestore.collection('status').add(
      {
        'image': url,
        'StatusMessage': statusMessage.text,
        'time': DateTime.now(),
        'name': PrefrenceManager.getName()
      },
    ).catchError((e) {
      statusController.isNotLoaded();
    });
    Get.offAll(() => HomeScreen(), transition: Transition.leftToRight);
    statusController.isNotLoaded();
  }
}
