import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/category_model.dart';
import 'package:faskes/pages/screens/admin/add_category.dart';
import 'package:faskes/pages/screens/widgets/tile_widget.dart';
import 'package:flutter/material.dart';

class FaskesCategories extends StatefulWidget {
  const FaskesCategories({super.key});

  @override
  State<FaskesCategories> createState() => _FaskesCategoriesState();
}

class _FaskesCategoriesState extends State<FaskesCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Kategori Fasilitas Kesehatan"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to add category screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCategory()),
          );
        },
        child: const Icon(Icons.add),
      ),
      // steam builder from firestore
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // convert snapshot data to list of category model
            final List<CategoryModel> catList = snapshot.data!.docs
                .map((e) => CategoryModel.fromJson(e.data()))
                .toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                itemCount: catList.length,
                itemBuilder: (context, index) {
                  return TileItem(item: catList[index]);
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
