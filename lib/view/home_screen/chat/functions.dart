import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../../common/colors.dart';
import '../../prefrence_manager.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
callNumber(String phoneNumber, String name, String image, time, uid) async {
  String number = phoneNumber;
  String userName = name;
  String userImage = image;

  await FlutterPhoneDirectCaller.callNumber(number);

  firebaseFirestore
      .collection('calls')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('calls')
      .add({
    'image': userImage,
    'name': userName,
    'number': phoneNumber,
    'time': time,
    'uid': firebaseAuth.currentUser!.uid,
    'type': 'voice'
  });
  firebaseFirestore.collection('calls').doc(uid).collection('calls').add({
    'image': PrefrenceManager.getImage(),
    'name': PrefrenceManager.getName(),
    'number': PrefrenceManager.getNumber(),
    'time': time,
    'type': 'voice',
    'uid': firebaseAuth.currentUser!.uid
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
