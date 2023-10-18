class CategoryModel {
  String? id;
  String? name;
  String? desc;

  CategoryModel({this.id, this.name, this.desc});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
