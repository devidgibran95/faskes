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

  getRatingAverage(List<RatingModel> ratings) {
    // get average rating from list of rating
    double totalRating = 0;

    for (var element in ratings) {
      totalRating += element.rating!;
    }

    return totalRating / ratings.length;
  }
}
