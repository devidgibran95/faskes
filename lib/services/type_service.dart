import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/type_model.dart';

class TypeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  add(TypeModel type) {
    // add category to firestore
    try {
      final c = _firestore.collection('types').add(type.toJson());

      c.then((value) {
        value.update({'id': value.id});
      });
    } catch (e) {
      rethrow;
    }
  }

  //get types from firestore
  Future<List<TypeModel>> getTypes() async {
    try {
      final typeDocs = await _firestore.collection('types').get();
      final typeList =
          typeDocs.docs.map((e) => TypeModel.fromJson(e.data())).toList();

      return typeList;
    } catch (e) {
      rethrow;
    }
  }

  // get type count
  Future<int> getTypeCount() async {
    try {
      final typeDocs = await _firestore.collection('types').get();
      final typeList =
          typeDocs.docs.map((e) => TypeModel.fromJson(e.data())).toList();

      return typeList.length;
    } catch (e) {
      rethrow;
    }
  }

  // get type by id
  Future<TypeModel> getTypeById(String id) async {
    try {
      final typeDoc = await _firestore.collection('types').doc(id).get();
      final typeData = typeDoc.data() as Map<String, dynamic>;
      final typeModel = TypeModel.fromJson(typeData);

      return typeModel;
    } catch (e) {
      rethrow;
    }
  }
}
