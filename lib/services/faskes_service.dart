import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';

class FaskesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FaskesModel>> getFaskes() async {
    try {
      final faskesDocs = await _firestore.collection('faskes').get();
      final faskesList =
          faskesDocs.docs.map((e) => FaskesModel.fromJson(e.data())).toList();

      return faskesList;
    } catch (e) {
      print('Error getting faskes: $e');
      rethrow;
    }
  }

  // add faskes
  Future<String> add(FaskesModel faskesModel) async {
    // add faskes to firestore
    String id = '';

    // return value id

    try {
      DocumentReference? c =
          await _firestore.collection('faskes').add(faskesModel.toJson());

      c.update({'id': c.id});

      return c.id;
    } catch (e) {
      print('Error adding faskes: $e');
      rethrow;
    }
  }

  updateFaskesImageUrl(String id, String imageUrl) {
    // update url image of faskes based on id
    try {
      _firestore.collection('faskes').doc(id).update({'imageUrl': imageUrl});
    } catch (e) {
      print('Error updating faskes: $e');
      rethrow;
    }
  }

  //get faskes count
  Future<int> getFaskesCount() async {
    try {
      final faskesDocs = await _firestore.collection('faskes').get();
      final faskesList =
          faskesDocs.docs.map((e) => FaskesModel.fromJson(e.data())).toList();

      return faskesList.length;
    } catch (e) {
      print('Error getting faskes: $e');
      rethrow;
    }
  }
}
