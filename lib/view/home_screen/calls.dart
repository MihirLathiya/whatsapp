import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/view/home_screen/chat_room/functions.dart';

import '../../controller/mobile_auth_controller.dart';
import '../common/colors.dart';
import '../common/text.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Calls extends StatefulWidget {
  const Calls({Key? key}) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: firebaseFirestore
          .collection('calls')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('calls')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var info = snapshot.data!.docs;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: info.length,
            itemBuilder: (context, index) {
              return Container(
                height: height * 0.09,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
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
                        '${info[index]['image']}',
                        fit: BoxFit.cover,
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
                          text: '${info[index]['name']}',
                          size: height * 0.02,
                          weight: FontWeight.w500,
                        ),
                        Ts(
                          text: '${info[index]['number']}',
                          size: height * 0.015,
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        await callNumber(
                            info[index]['number'],
                            info[index]['name'],
                            info[index]['image'],
                            DateTime.now());
                      },
                      icon: Icon(
                        Icons.call,
                        color: AppColors.mainColor,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
