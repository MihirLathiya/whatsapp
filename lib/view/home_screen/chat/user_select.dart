import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/controller/controllers.dart';
import '../../../common/button.dart';
import '../../../common/colors.dart';
import '../../../common/text.dart';
import 'chatRoom.dart';
import 'functions.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class UserSelectScreen extends StatefulWidget {
  const UserSelectScreen({Key? key}) : super(key: key);

  @override
  State<UserSelectScreen> createState() => _UserSelectScreenState();
}

class _UserSelectScreenState extends State<UserSelectScreen> {
  SearchPanelController searchPanelController =
      Get.put(SearchPanelController());
  TextEditingController _search = TextEditingController();
  String search = '';
  String? roomId;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => searchPanelController.isSearch.value == false
                  ? Container(
                      color: AppColors.mainColor,
                      height: height * 0.08,
                      width: width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    search = '';
                                  });
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.white,
                                ),
                              ),
                              Ts(
                                text: 'Select Contact',
                                size: height * 0.02,
                                color: AppColors.white,
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isSearch = true;
                                  // });

                                  searchPanelController.isSearched();
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: AppColors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_vert_sharp,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: AppColors.white,
                      height: height * 0.08,
                      width: width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isSearch = false;
                                  // });
                                  searchPanelController.isNotSearched();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _search,
                                  onChanged: (value) {
                                    setState(() {
                                      search = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02),
                                    hintText: "Search....",
                                    hintStyle: TextStyle(
                                      fontSize: height * 0.022,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('user')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> info = snapshot.data!.docs;
                    if (search.isNotEmpty) {
                      info = info.where((element) {
                        return element
                            .get('name')
                            .toString()
                            .toLowerCase()
                            .contains(search.toLowerCase());
                      }).toList();
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: info.length,
                      itemBuilder: (context, index) {
                        return firebaseAuth.currentUser!.uid ==
                                snapshot.data!.docs[index].id
                            ? SizedBox()
                            : Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: height * 0.09,
                                      width: width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.04),
                                      child: Row(
                                        children: [
                                          Container(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            height: height * 0.06,
                                            width: height * 0.06,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.textColor
                                                  .withAlpha(100),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                  ),
                                  Button(
                                    buttonName: 'message',
                                    onTap: () async {
                                      roomId = await chatRoomId(
                                        '${snapshot.data!.docs[index].id}',
                                        '${firebaseAuth.currentUser!.uid}',
                                      );

                                      Get.to(
                                        () => ChatRoom(
                                          chatRoomId: roomId,
                                          image: '${info[index]['image']}',
                                          name: '${info[index]['name']}',
                                          number: '${info[index]['number']}',
                                          uid: snapshot.data!.docs[index].id,
                                        ),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    buttonColor: AppColors.mainColor,
                                  ),
                                  SizedBox(width: width * 0.05)
                                ],
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
          ],
        ),
      ),
    );
  }
}
