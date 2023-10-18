import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/fav_faskes_model.dart';

class FavFaskesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FavFaskesModel>> getFavFaskes() async {
    try {
      final favFaskesDocs = await _firestore.collection('favFaskes').get();
      final favFaskesList = favFaskesDocs.docs
          .map((e) => FavFaskesModel.fromJson(e.data()))
          .toList();

      return favFaskesList;
    } catch (e) {
      print('Error getting favFaskes: $e');
      rethrow;
    }
  }

  // add favFaskes
  Future<String> add(FavFaskesModel favFaskesModel) async {
    // add favFaskes to firestore
    String id = '';

    try {
      DocumentReference? c =
          await _firestore.collection('favFaskes').add(favFaskesModel.toJson());

      c.update({'id': c.id});

      return c.id;
    } catch (e) {
      print('Error adding favFaskes: $e');
      rethrow;
    }
  }

  //remove favFaskes
  Future<void> remove(FavFaskesModel favFaskesModel) async {
    // remove where user id and faskes id match

    try {
      await _firestore
          .collection('favFaskes')
          .where('userId', isEqualTo: favFaskesModel.userId)
          .where('faskesId', isEqualTo: favFaskesModel.faskesId)
          .get()
          .then((value) {
        value.docs.first.reference.delete();
      });
    } catch (e) {
      print('Error removing favFaskes: $e');
      rethrow;
    }
  }

  getFavFaskesByUserId(String userId) {
    // get faskes by user id
    try {
      final favFaskesDocs = _firestore
          .collection('favFaskes')
          .where('userId', isEqualTo: userId)
          .get();

      return favFaskesDocs.then((value) {
        final favFaskesList =
            value.docs.map((e) => FavFaskesModel.fromJson(e.data())).toList();

        return favFaskesList;
      });
    } catch (e) {
      print('Error getting favFaskes: $e');
      rethrow;
    }
  }
}
