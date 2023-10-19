import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/rating_model.dart';
import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/user/add_rating.dart';
import 'package:faskes/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class RatingList extends StatefulWidget {
  FaskesModel faskes;
  RatingList({required this.faskes, super.key});

  @override
  State<RatingList> createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  UserModel? currentUser;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    UserModel? user =
        await UserService().getUser(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rating ${widget.faskes.name}'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddRating(
                        faskes: widget.faskes,
                      )));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ratings')
            .where('faskesId', isEqualTo: widget.faskes.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<RatingModel> catList = snapshot.data!.docs
                .map((e) => RatingModel.fromJson(e.data()))
                .toList();

            return catList.isEmpty
                ? const Center(
                    child:
                        Text("Belum ada ulasan untuk fasilitas kesehatan ini."),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListView.builder(
                      itemCount: catList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ListTile(
                              leading: GFAvatar(
                                  backgroundImage: NetworkImage(
                                      currentUser != null
                                          ? currentUser!.image!
                                          : "")),
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentUser == null
                                            ? "-"
                                            : currentUser!.name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        // format date to,e to "10 Oktober 2021 10:00 WIB"
                                        "${catList[index].createdAt!.day}-${catList[index].createdAt!.month}-${catList[index].createdAt!.year} ${catList[index].createdAt!.hour}:${catList[index].createdAt!.minute} WIB",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GFRating(
                                      onChanged: (value) {},
                                      value: catList[index].rating!.toDouble()),
                                  const SizedBox(height: 10),
                                  Text(
                                    catList[index].comment!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
