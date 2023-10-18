import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  add(CategoryModel categoryModel) {
    // add category to firestore
    try {
      final c = _firestore.collection('categories').add(categoryModel.toJson());

      c.then((value) {
        value.update({'id': value.id});
      });
    } catch (e) {
      print('Error adding cat: $e');
      rethrow;
    }
  }

  // get categories from firestore
  Future<List<CategoryModel>> getCategories() async {
    try {
      final catDocs = await _firestore.collection('categories').get();
      final catList =
          catDocs.docs.map((e) => CategoryModel.fromJson(e.data())).toList();

      return catList;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }

  // get category count
  Future<int> getCategoryCount() async {
    try {
      final catDocs = await _firestore.collection('categories').get();
      final catList =
          catDocs.docs.map((e) => CategoryModel.fromJson(e.data())).toList();

      return catList.length;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }

  // get category by id
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final catDoc = await _firestore.collection('categories').doc(id).get();
      final catData = catDoc.data() as Map<String, dynamic>;
      final catModel = CategoryModel.fromJson(catData);

      return catModel;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }
}
