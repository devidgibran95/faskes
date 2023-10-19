import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/rating_model.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get faskes ratings from firestore by id
  Future<List<RatingModel>> getFaskesRatings(String id) async {
    try {
      final ratingDocs = await _firestore
          .collection('ratings')
          .where('faskesId', isEqualTo: id)
          .get();

      final ratingList =
          ratingDocs.docs.map((e) => RatingModel.fromJson(e.data())).toList();

      return ratingList;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }

  double getRatingAverage(List<RatingModel> ratings) {
    // get average rating from list of rating
    double totalRating = 0;

    for (var element in ratings) {
      totalRating += element.rating!;
    }

    return totalRating / ratings.length;
  }

  // add rating
  Future<void> addRating(RatingModel rating) async {
    try {
      final doc = await _firestore.collection('ratings').add(rating.toJson());

      //update id
      await doc.update({'id': doc.id});
    } catch (e) {
      print('Error adding rating: $e');
      rethrow;
    }
  }
}
