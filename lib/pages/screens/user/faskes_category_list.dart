import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/category_model.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/screens/widgets/faskes_card_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FaskesCategoryList extends StatefulWidget {
  CategoryModel category;
  FaskesCategoryList({required this.category, super.key});

  @override
  State<FaskesCategoryList> createState() => _FaskesCategoryListState();
}

class _FaskesCategoryListState extends State<FaskesCategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Daftar ${widget.category.name}'),
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('faskes')
              .where('categoryId', isEqualTo: widget.category.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FaskesModel> catList = snapshot.data!.docs
                  .map((e) => FaskesModel.fromJson(e.data()))
                  .toList();

              return catList.isEmpty
                  ? const Center(
                      child: Text(
                          "Belum ada fasilitas kesehatan dengan kategori ini."),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: ListView.builder(
                        itemCount: catList.length,
                        itemBuilder: (context, index) {
                          return FaskesCardWidget(
                            faskes: catList[index],
                          );
                        },
                      ),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
