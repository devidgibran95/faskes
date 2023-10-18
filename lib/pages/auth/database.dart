import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static CollectionReference faskesCollection =
      FirebaseFirestore.instance.collection('fasilitaskesehata');

  // static Future<void> createOrUpdateFaskes(String id,{String 'name',} async ){

  // }
}
