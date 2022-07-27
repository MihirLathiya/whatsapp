import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/view/common/colors.dart';
import 'package:whatsapp/view/common/text.dart';

class StatusView extends StatefulWidget {
  final status;
  final comment;
  const StatusView({Key? key, this.status, this.comment}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  PageController pageController = Get.put(PageController(initialPage: 0));
  Timer? timer;
  @override
  initState() {
    timer = Timer(
      Duration(seconds: 5),
      () {
        Get.back();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onDoubleTap: () {
              Get.back();
            },
            onTap: () {
              pageController.nextPage(
                  duration: Duration(microseconds: 1),
                  curve: Curves.easeInCirc);
            },
            child: Hero(
              tag: '${widget.status}',
              child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage('${widget.status}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: Get.height * 0.05,
                      width: Get.width,
                      color: Colors.black54,
                      child: Center(
                        child: Ts(
                          text: '${widget.comment}',
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.07,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
