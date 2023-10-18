import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/type_model.dart';
import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/admin/add_type.dart';
import 'package:faskes/pages/screens/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Pengguna"),
      ),
      // steam builder from firestore
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // convert snapshot data to list of category model
            final List<UserModel> catList = snapshot.data!.docs
                .map((e) => UserModel.fromJson(e.data()))
                .toList();

            catList.removeWhere((element) => element.name == "admin");

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                itemCount: catList.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: NetworkImage(catList[index].image ?? ""),
                    ),
                    titleText: catList[index].name,
                    subTitleText: catList[index].email,
                  ));
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
