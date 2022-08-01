import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/view/prefrence_manager.dart';
import '../../../common/colors.dart';
import '../../../common/text.dart';
import 'home_screen/chat/functions.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Demo extends StatefulWidget {
  final chatRoomId;
  final image;
  final number;
  final uid;
  final name;
  const Demo(
      {Key? key, this.chatRoomId, this.image, this.name, this.number, this.uid})
      : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with WidgetsBindingObserver {
  TextEditingController message = TextEditingController();
  File? file;
  String? name;

  /// pickImage
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      File doc = File(result.files.single.path.toString());

      setState(() {
        file = doc;
      });
      name = result.names.first.toString();

      // uploadDoc();
    } else {
      return null;
    }
  }

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            pickImage();
          },
          child: Container(
            height: height * 0.1,
            width: height * 0.1,
            child: file != null
                ? Image.file(
                    file!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/background.jpg',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
