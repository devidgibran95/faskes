import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/region_model.dart';
import 'package:faskes/pages/screens/admin/add_region.dart';
import 'package:faskes/pages/screens/widgets/tile_widget.dart';
import 'package:flutter/material.dart';

class FaskesRegions extends StatefulWidget {
  const FaskesRegions({super.key});

  @override
  State<FaskesRegions> createState() => _FaskesRegionsState();
}

class _FaskesRegionsState extends State<FaskesRegions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Wilayah Fasilitas Kesehatan"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to add category screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRegion()),
          );
        },
        child: const Icon(Icons.add),
      ),
      // steam builder from firestore
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("regions").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // convert snapshot data to list of category model
            final List<RegionModel> catList = snapshot.data!.docs
                .map((e) => RegionModel.fromJson(e.data()))
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
              child: Text("Belum ada data wilayah fasilitas kesehatan"),
            );
          }
        },
      ),
    );
  }
}
