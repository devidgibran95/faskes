import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/region_model.dart';

class RegionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  add(RegionModel regionModel) {
    // add category to firestore
    try {
      final c = _firestore.collection('regions').add(regionModel.toJson());

      c.then((value) {
        value.update({'id': value.id});
      });
    } catch (e) {
      print('Error adding cat: $e');
      rethrow;
    }
  }

  // get regions from firestore
  Future<List<RegionModel>> getRegions() async {
    try {
      final regionDocs = await _firestore.collection('regions').get();
      final regionList =
          regionDocs.docs.map((e) => RegionModel.fromJson(e.data())).toList();

      return regionList;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }

  //get region count
  Future<int> getRegionCount() async {
    try {
      final regionDocs = await _firestore.collection('regions').get();
      final regionList =
          regionDocs.docs.map((e) => RegionModel.fromJson(e.data())).toList();

      return regionList.length;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }

  // get region by id
  Future<RegionModel> getRegionById(String id) async {
    try {
      final regionDoc = await _firestore.collection('regions').doc(id).get();
      final regionData = regionDoc.data() as Map<String, dynamic>;
      final regionModel = RegionModel.fromJson(regionData);

      return regionModel;
    } catch (e) {
      print('Error getting cat: $e');
      rethrow;
    }
  }
}
