import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String?> uploadFile({File? file, String? filename}) async {
  print("File path:${file!.path}");
  try {
    var response = await firebase_storage.FirebaseStorage.instance
        .ref("product_image/$filename")
        .putFile(file);
    String url =
        await response.storage.ref("product_image/$filename").getDownloadURL();
    print('IMAHGE URL $url');
    return url;
  } on firebase_storage.FirebaseException catch (e) {
    print(e);
  }
}
