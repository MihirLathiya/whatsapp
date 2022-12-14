import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/view/prefrence_manager.dart';
import '../../../common/colors.dart';
import '../../../common/text.dart';
import 'functions.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class ChatRoom extends StatefulWidget {
  final chatRoomId;
  final image;
  final number;
  final uid;
  final name;
  const ChatRoom(
      {Key? key, this.chatRoomId, this.image, this.name, this.number, this.uid})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  TextEditingController message = TextEditingController();
  setStatus(
    String status,
  ) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .update({"status": status});
  }

  setStatus1(String status) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .collection('users')
        .doc(widget.uid)
        .update({"status": status});
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      setStatus("Offline");
      // offline
    }
    super.didChangeAppLifecycleState(state);
  }

  initState() {
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
    super.initState();
  }

  String? status;
  bool remove = false;
  getMark() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .where('sendBy', isEqualTo: widget.uid)
        .where('isCheck', isEqualTo: false);
    var nnj = await info.get();
    for (var element in nnj.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(element.id)
          .update({"isCheck": true});
    }
  }

  removeMark() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .where('isDelete', isEqualTo: true);
    var nnj = await info.get();
    for (var element in nnj.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(element.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () async {
                print('CALL${widget.number}');
                await callNumber(widget.number, widget.name, widget.image,
                    DateTime.now(), widget.uid);
              },
              icon: Icon(
                Icons.phone,
                color: AppColors.white,
              ),
            ),
            if (remove == true)
              IconButton(
                splashRadius: 20,
                onPressed: () async {
                  removeMark();
                  setState(() {
                    remove = false;
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.white,
                ),
              ),
            PopupMenuButton(
              color: AppColors.white,
              icon: Icon(
                Icons.more_vert,
                color: AppColors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Report"),
                ),
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Block"),
                ),
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Clear chat"),
                ),
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Export chat"),
                ),
              ],
            ),
          ],
          title: StreamBuilder(
            stream: firebaseFirestore
                .collection('user')
                .doc(widget.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasData) {
                return remove == true
                    ? SizedBox()
                    : Row(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            height: height * 0.04,
                            width: height * 0.04,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.textColor,
                            ),
                            child: Image.network(
                              '${widget.image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.035,
                          ),
                          snapshot.data!['status'] == 'Online'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Ts(
                                      text: '${widget.name}',
                                      size: height * 0.025,
                                    ),
                                    Ts(
                                      text: "${snapshot.data!['status']}",
                                      size: height * 0.012,
                                    ),
                                  ],
                                )
                              : Ts(
                                  text: '${widget.name}',
                                  size: height * 0.025,
                                ),
                        ],
                      );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('chatRoom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    getMark();
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        var message = snapshot.data!.docs[index];
                        DateTime myTime = (message['time']).toDate();
                        var x = DateFormat.jm().format(myTime);
                        var xy = message['isDelete'];
                        return InkWell(
                          onLongPress: () {
                            setState(() {
                              remove = true;
                            });
                          },
                          onTap: () {
                            setState(() {
                              remove = false;
                            });
                          },
                          child: Row(
                            children: [
                              // remove == true
                              //     ? Checkbox(
                              //         value: xy,
                              //         onChanged: (val) {
                              //           setState(() {
                              //             xy = val!;
                              //           });
                              //           firebaseFirestore
                              //               .collection('chatRoom')
                              //               .doc(widget.chatRoomId)
                              //               .collection('chats')
                              //               .doc(message.id)
                              //               .update({'isDelete': xy});
                              //         })
                              //     : SizedBox(),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  alignment: message['sendBy'] ==
                                          firebaseAuth.currentUser!.uid
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 11),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        topLeft: message['sendBy'] ==
                                                firebaseAuth.currentUser!.uid
                                            ? Radius.circular(12)
                                            : Radius.circular(0),
                                        bottomRight: Radius.circular(12),
                                        topRight: message['sendBy'] ==
                                                firebaseAuth.currentUser!.uid
                                            ? Radius.circular(0)
                                            : Radius.circular(12),
                                      ),
                                      color: message['sendBy'] ==
                                              firebaseAuth.currentUser!.uid
                                          ? AppColors.sendMessage
                                          : AppColors.white,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            message['message'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: height * 0.016,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Ts(
                                                  text: x,
                                                  size: height * 0.0128,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  width: width * 0.013,
                                                ),
                                                message['sendBy'] ==
                                                        firebaseAuth
                                                            .currentUser!.uid
                                                    ? message['isCheck'] == true
                                                        ? Icon(
                                                            Icons.done_all,
                                                            size: height * 0.02,
                                                            color: AppColors
                                                                .mainColor,
                                                          )
                                                        : Icon(
                                                            Icons.check,
                                                            size:
                                                                height * 0.018,
                                                            color: Colors.grey,
                                                          )
                                                    : SizedBox()
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
              ),
            ),
            sendMessage(width, height)
          ],
        ),
      ),
    );
  }

  Padding sendMessage(double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.015),
      child: Row(
        children: [
          Container(
            height: height * 0.06,
            width: width * 0.82,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: SizedBox(
              height: height * 0.06,
              width: width * 0.82,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: message,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                      onPressed: () {},
                      splashRadius: 10,
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.grey,
                      )),
                  suffixIcon: message.value.text.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              IconButton(
                                onPressed: () {
                                  showMediaSheet();
                                },
                                splashRadius: 10,
                                icon: Transform.rotate(
                                  angle: 5.5,
                                  child: Icon(
                                    Icons.attach_file,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: height * 0.015,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.currency_rupee,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  splashRadius: 10,
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ))
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              splashRadius: 10,
                              icon: Transform.rotate(
                                angle: 5.5,
                                child: Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                  hintText: "Message",
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
          message.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    onSendMessage();
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.mainColor,
                    radius: height * 0.027,
                    child: Icon(
                      Icons.send,
                      color: AppColors.white,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: AppColors.mainColor,
                    radius: height * 0.027,
                    child: Icon(
                      Icons.keyboard_voice,
                      color: AppColors.white,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  void onSendMessage() async {
    if (message.text.isNotEmpty) {
      if (message.text.isNotEmpty) {
        Map<String, dynamic> messages = {
          'sendBy': firebaseAuth.currentUser!.uid,
          'message': message.text,
          'type': 'text',
          'FCMTOKEN': PrefrenceManager.getToken(),
          'time': DateTime.now(),
          'isDelete': false,
          'isCheck': false
        };

        firebaseFirestore
            .collection('chatRoom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .add(messages);
        message.clear();

        firebaseFirestore
            .collection('user')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('users')
            .doc(widget.uid)
            .set({
          'name': widget.name,
          'time': DateTime.now(),
          'number': widget.number,
          'image': widget.image,
          'status': 'Offline'
        });
        firebaseFirestore
            .collection('user')
            .doc(widget.uid)
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          'name': PrefrenceManager.getName(),
          'time': DateTime.now(),
          'number': PrefrenceManager.getNumber(),
          'image': PrefrenceManager.getImage(),
          'status': 'Offline'
        });
      } else {
        print('some text add');
      }
    }
  }

  void showMediaSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container();
      },
    );
  }
}
