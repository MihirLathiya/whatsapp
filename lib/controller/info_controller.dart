import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../common/colors.dart';

class InfoController extends GetxController {
  String? Img;
  String? name;
  String? bio;
  String? number;
  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  void getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? getUserData = user.data();
    name = getUserData!['name'];
    bio = getUserData['bio'];
    Img = getUserData['image'];
    number = '+91 ' + getUserData['number'];

    update();
  }

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:$file");

    try {
      var response = await FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file!);

      var data =
          await response.storage.ref("user_image/$filename").getDownloadURL();
      update();
      return data;
    } on firebase_storage.FirebaseException catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  Future updateData(File image) async {
    String? userImage = await uploadFile(
        file: image, filename: "${firebaseAuth.currentUser?.uid}");
    FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'image': userImage});
    update();
  }

  Future updateName(String name) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'name': name});
    update();
  }

  Future updateBio(String bio) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'bio': bio});
    update();
  }
}
