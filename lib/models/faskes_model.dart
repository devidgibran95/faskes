class FaskesModel {
  String? name;
  String? address;
  String? phone;
  String? desc;
  String? regionId;
  String? categoryId;
  String? typeId;
  String? imageUrl;
  double? latitude;
  double? longitude;
  String? id;

  FaskesModel({
    this.name,
    this.address,
    this.phone,
    this.desc,
    this.regionId,
    this.categoryId,
    this.typeId,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.id,
  });

  FaskesModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    desc = json['desc'];
    regionId = json['regionId'];
    categoryId = json['categoryId'];
    typeId = json['typeId'];
    imageUrl = json['imageUrl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'desc': desc,
      'regionId': regionId,
      'categoryId': categoryId,
      'typeId': typeId,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'id': id,
    };
  }
}
