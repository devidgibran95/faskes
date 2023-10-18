class TypeModel {
  String? id;
  String? name;
  String? desc;

  TypeModel({this.id, this.name, this.desc});

  TypeModel.fromJson(Map<String, dynamic> json) {
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
