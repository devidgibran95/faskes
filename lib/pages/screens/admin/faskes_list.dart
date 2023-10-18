import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/screens/admin/add_faskes.dart';
import 'package:faskes/pages/screens/widgets/faskes_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class FaskesList extends StatefulWidget {
  const FaskesList({super.key});

  @override
  State<FaskesList> createState() => _FaskesListState();
}

class _FaskesListState extends State<FaskesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Fasilitas Kesehatan"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to add category screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFaskes()),
          );
        },
        child: const Icon(Icons.add),
      ),
      // steam builder from firestore
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("faskes").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // convert snapshot data to list of category model
            final List<FaskesModel> catList = snapshot.data!.docs
                .map((e) => FaskesModel.fromJson(e.data()))
                .toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                itemCount: catList.length,
                itemBuilder: (context, index) {
                  // return a card with image and text
                  return FaskesCardWidget(faskes: catList[index]);
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
