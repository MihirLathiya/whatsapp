import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/view/common/text.dart';
import 'package:whatsapp/view/home_screen/chat_room/chatRoom.dart';
import '../../common/colors.dart';
import 'functions.dart';

class Chats extends StatefulWidget {
  final search;
  const Chats({Key? key, this.search}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String? currentUserName;
  // String? roomId;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print('SEARCHTEXT${widget.search}');

    return StreamBuilder(
      stream: firebaseFirestore
          .collection('user')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> info = snapshot.data!.docs;
          print("length======>${info.length}");
          print("Text======>${widget.search}");
          if (widget.search.isNotEmpty) {
            info = info.where((element) {
              return element
                  .get('name')
                  .toString()
                  .toLowerCase()
                  .contains(widget.search.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: info.length,
            itemBuilder: (context, index) {
              return snapshot.data!.docs[index]['roomId'] == '0'
                  ? SizedBox()
                  : InkWell(
                      onTap: () async {
                        // roomId = await chatRoomId(
                        //     '${firebaseAuth.currentUser!.uid}',
                        //     '${info[index].id}');
                        // print("ROOMID$roomId");
                        Get.to(
                          () => ChatRoom(
                            chatRoomId: '${info[index]['roomId']}',
                            image: '${info[index]['image']}',
                            name: '${info[index]['name']}',
                            number: '${info[index]['number']}',
                            uid: info[index].id,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Container(
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
                                  text: '${info[index]['bio']}',
                                  size: height * 0.015,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            )
                          ],
                        ),
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
