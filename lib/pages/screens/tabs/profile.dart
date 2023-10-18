import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ProfileScreen extends StatefulWidget {
  UserModel user;
  ProfileScreen({required this.user, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        elevation: 0,
        title: const Text("Profil"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("id", isEqualTo: widget.user.id)
                    .snapshots()
                    .map((querySnapshot) => querySnapshot.docs
                        .map((e) => UserModel.fromJson(e.data()))
                        .toList()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final user = snapshot.data!.first;

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GFAvatar(
                              backgroundImage: NetworkImage(user.image ??
                                  "https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-and-shapes-3/177800/130-512.png"),
                              shape: GFAvatarShape.standard,
                              size: 100,
                            ),
                            // make name text big and bold
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Text(user.name!,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 15),
                                  Text(
                                    user.email!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    user.phone!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    user.address!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    height: 50,
                                    child: GFButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {},
                                        color: Colors.blue,
                                        fullWidthButton: true,
                                        text: 'Edit Profil'),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 50,
                                    child: GFButton(
                                        icon: const Icon(Icons.exit_to_app,
                                            color: Colors.white),
                                        onPressed: () {
                                          FirebaseAuth.instance
                                              .signOut()
                                              .then((value) {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();

                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: const LoginOrRegister(),
                                              withNavBar: false,
                                            );
                                          });
                                        },
                                        color: Colors.red,
                                        fullWidthButton: true,
                                        text: 'Keluar'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
