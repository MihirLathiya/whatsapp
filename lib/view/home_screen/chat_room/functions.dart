import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../../controller/mobile_auth_controller.dart';

callNumber(String phoneNumber) async {
  String number = phoneNumber;

  await FlutterPhoneDirectCaller.callNumber(number);
}

/// chateRoomId
Future<String> chatRoomId(String user1, String user2) async {
  if (user1[0].toLowerCase().codeUnitAt(0) >
      user2.toLowerCase().codeUnitAt(0)) {
    return '$user1$user2';
  } else {
    return '$user2$user1';
  }
}

/// status oneline / offline
