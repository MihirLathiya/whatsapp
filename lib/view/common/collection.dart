import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/view/common/colors.dart';

DocumentReference userDoc =
    firebaseFirestore.collection('user').doc(firebaseAuth.currentUser!.uid);
