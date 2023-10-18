class RegionModel {
  String? id;
  String? name;
  String? desc;

  RegionModel({this.id, this.name, this.desc});

  RegionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
    };
  }
}
