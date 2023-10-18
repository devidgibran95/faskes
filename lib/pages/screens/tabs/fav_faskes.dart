import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/fav_faskes_model.dart';
import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/widgets/faskes_card_widget.dart';
import 'package:faskes/services/faskes_service.dart';
import 'package:flutter/material.dart';

class FavFaskesScreen extends StatefulWidget {
  UserModel userModel;
  FavFaskesScreen({required this.userModel, super.key});

  @override
  State<FavFaskesScreen> createState() => _FavFaskesScreenState();
}

class _FavFaskesScreenState extends State<FavFaskesScreen> {
  List<FaskesModel>? allFaskes;

  @override
  void initState() {
    getAllFaskes();
    super.initState();
  }

  getAllFaskes() {
    try {
      FaskesService().getFaskes().then((value) {
        setState(() {
          allFaskes = value;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fasilitas Kesehatan Favorit"),
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("favFaskes")
              .where('userId', isEqualTo: widget.userModel.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // convert snapshot data to list of category model
              final List<FavFaskesModel> catList = snapshot.data!.docs
                  .map((e) => FavFaskesModel.fromJson(e.data()))
                  .toList();

              List<FaskesModel> fav = [];
              for (var a in allFaskes!) {
                // check if the faskes id is in fav list
                if (catList.any((element) => element.faskesId == a.id)) {
                  fav.add(a);
                }
              }

              return fav.isEmpty
                  ? const Center(
                      child: Text(
                          "Anda belum memiliki fasilitas kesehatan favorit"))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: ListView.builder(
                        itemCount: fav.length,
                        itemBuilder: (context, index) {
                          // return a card with image and text
                          return FaskesCardWidget(faskes: fav[index]);
                        },
                      ),
                    );
            } else {
              print(snapshot.data);
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
