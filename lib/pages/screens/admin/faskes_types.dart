import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/type_model.dart';
import 'package:faskes/pages/screens/admin/add_type.dart';
import 'package:faskes/pages/screens/widgets/tile_widget.dart';
import 'package:flutter/material.dart';

class FaskesTypes extends StatefulWidget {
  const FaskesTypes({super.key});

  @override
  State<FaskesTypes> createState() => _FaskesTypesState();
}

class _FaskesTypesState extends State<FaskesTypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Jenis Fasilitas Kesehatan"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to add category screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddType()),
          );
        },
        child: const Icon(Icons.add),
      ),
      // steam builder from firestore
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("types").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // convert snapshot data to list of category model
            final List<TypeModel> catList = snapshot.data!.docs
                .map((e) => TypeModel.fromJson(e.data()))
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
              child: Text("Belum ada data jenis fasilitas kesehatan"),
            );
          }
        },
      ),
    );
  }
}
