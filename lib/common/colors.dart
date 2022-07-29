import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class AppColors {
  static Color textColor = Color(0xff898989);
  static Color mainColor = Color(0xff128c7e);
  static Color white = Color(0xffffffff);
  static Color sendMessage = Color(0xffe5ffcc);
  static Color online = Colors.green;
  static Color trans = Colors.transparent;
}

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
