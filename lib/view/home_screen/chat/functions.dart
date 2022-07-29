import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../../common/colors.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
callNumber(String phoneNumber, String name, String image, time) async {
  String number = phoneNumber;
  String userName = name;
  String userImage = image;

  await FlutterPhoneDirectCaller.callNumber(number);

  await firebaseFirestore
      .collection('calls')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('calls')
      .add({
    'image': userImage,
    'name': userName,
    'number': phoneNumber,
    'time': time
  });
}

/// chatRoomId
Future<String> chatRoomId(String user1, String user2) async {
  if (user1[0].toLowerCase().codeUnitAt(0) >
      user2.toLowerCase().codeUnitAt(0)) {
    return '$user1$user2';
  } else {
    return '$user2$user1';
  }
}

/// status online / offline
setStatus(String status) async {
  await FirebaseFirestore.instance
      .collection("user")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"status": status});
}
