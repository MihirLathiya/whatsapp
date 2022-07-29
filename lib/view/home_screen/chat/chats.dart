import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../common/text.dart';
import 'chatRoom.dart';
import 'functions.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Chats extends StatefulWidget {
  final search;
  const Chats({Key? key, this.search}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: firebaseFirestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('users')
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
              var x =
                  firebaseAuth.currentUser!.uid[0].toLowerCase().codeUnitAt(0) >
                          info[index].id.toLowerCase().codeUnitAt(0)
                      ? firebaseAuth.currentUser!.uid + info[index].id
                      : info[index].id + firebaseAuth.currentUser!.uid;
              return firebaseAuth.currentUser!.uid ==
                      snapshot.data!.docs[index].id
                  ? SizedBox()
                  : InkWell(
                      onTap: () async {
                        String roomId = await chatRoomId(
                            firebaseAuth.currentUser!.uid,
                            snapshot.data!.docs[index].id);
                        Get.to(
                          () => ChatRoom(
                            chatRoomId: roomId,
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
                                SizedBox(
                                  height: height * 0.02,
                                  width: width * 0.2,
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("chatRoom")
                                        .doc(x)
                                        .collection('chats')
                                        .orderBy('time', descending: true)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snap) {
                                      if (snap.hasData) {
                                        return ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: snap.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            var lastMess = snap
                                                .data!.docs[index]['message'];
                                            return Ts(
                                              text: lastMess,
                                              color: Colors.grey,
                                              size: height * 0.015,
                                              overFlow: TextOverflow.ellipsis,
                                            );
                                          },
                                        );
                                      } else {
                                        return Text("Available");
                                      }
                                    },
                                  ),
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
