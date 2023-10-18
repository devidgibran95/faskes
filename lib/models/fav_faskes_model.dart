class FavFaskesModel {
  String? id;
  String? faskesId;
  String? userId;

  FavFaskesModel({
    this.id,
    this.faskesId,
    this.userId,
  });

  FavFaskesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    faskesId = json['faskesId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faskesId': faskesId,
      'userId': userId,
    };
  }
}
