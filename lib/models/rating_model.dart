class RatingModel {
  String? id;
  String? faskesId;
  String? userId;
  String? comment;
  double? rating;
  DateTime? createdAt;

  RatingModel({
    this.id,
    this.faskesId,
    this.userId,
    this.comment,
    this.rating,
    this.createdAt,
  });

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    faskesId = json['faskesId'];
    userId = json['userId'];
    comment = json['comment'];
    rating = json['rating'];
    createdAt = json['createdAt'].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faskesId': faskesId,
      'userId': userId,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
