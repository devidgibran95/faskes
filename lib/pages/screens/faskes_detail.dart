import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/fav_faskes_model.dart';
import 'package:faskes/models/rating_model.dart';
import 'package:faskes/pages/screens/user/rating_list.dart';
import 'package:faskes/services/category_service.dart';
import 'package:faskes/services/fav_faskes_service.dart';
import 'package:faskes/services/region_service.dart';
import 'package:faskes/services/type_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:url_launcher/url_launcher.dart';

class FaskesDetail extends StatefulWidget {
  FaskesModel faskes;
  FaskesDetail({required this.faskes, super.key});

  @override
  State<FaskesDetail> createState() => _FaskesDetailState();
}

class _FaskesDetailState extends State<FaskesDetail> {
  String? categoryName, typeName, regionName;

  bool isFavorite = false;

  @override
  void initState() {
    getIdData();
    checkIfFavorite();
    super.initState();
  }

  // check if favorite
  checkIfFavorite() {
    try {
      FavFaskesService()
          .getFavFaskesByUserId(FirebaseAuth.instance.currentUser!.uid)
          .then((value) {
        print(value.length);
        List<FavFaskesModel> fav = [];
        for (var a in value) {
          fav.add(a);
        }

        if (fav.any((element) => element.faskesId == widget.faskes.id)) {
          setState(() {
            isFavorite = true;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  getIdData() {
    try {
      CategoryService().getCategoryById(widget.faskes.categoryId!).then(
        (value) {
          setState(() {
            categoryName = value.name;
          });

          TypeService().getTypeById(widget.faskes.typeId!).then(
            (value) {
              setState(() {
                typeName = value.name;
              });

              RegionService().getRegionById(widget.faskes.regionId!).then(
                (value) {
                  setState(() {
                    regionName = value.name;
                  });
                },
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not launch $googleUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Fasilitas Kesehatan"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Image.network(
                widget.faskes.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.faskes.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      // navigate to rating list page
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: RatingList(faskes: widget.faskes),
                        withNavBar: false,
                      );
                    },
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("ratings")
                          .where("faskesId", isEqualTo: widget.faskes.id)
                          .snapshots()
                          .map((querySnapshot) => querySnapshot.docs
                              .map((e) => RatingModel.fromJson(e.data()))
                              .toList()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<RatingModel> ratings = [];
                          for (var a in snapshot.data!) {
                            ratings.add(a);
                          }

                          // calcualte rating value average from ratings
                          double ratingValue = 0;
                          for (var a in ratings) {
                            ratingValue += a.rating!;
                          }

                          // calculate average
                          ratingValue = ratingValue / ratings.length;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GFRating(
                                onChanged: (value) {},
                                value: ratingValue.isNaN ? 0 : ratingValue,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "(${ratings.length} Ulasan)",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Chip(
                        label: Text(categoryName ?? "-"),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        label: Text(typeName ?? "-"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // create text with address and region name but the region name is bold
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 10),
                      RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${widget.faskes.address!}, ",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: regionName ?? "-",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 10),
                      Text(widget.faskes.phone!),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.faskes.desc!),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: GFButton(
                        icon: Icon(
                          isFavorite ? Icons.delete : Icons.favorite,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          FavFaskesModel fav = FavFaskesModel(
                            faskesId: widget.faskes.id,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                          );

                          isFavorite
                              ? FavFaskesService().remove(fav)
                              : FavFaskesService().add(fav);

                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        color: isFavorite ? Colors.red : Colors.orange,
                        fullWidthButton: true,
                        text: isFavorite
                            ? 'Hapus dari Favorit'
                            : 'Tambahkan ke Favorit'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: GFButton(
                        icon: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          openMap(widget.faskes.latitude!,
                              widget.faskes.longitude!);
                        },
                        color: Colors.blue,
                        fullWidthButton: true,
                        text: 'Dapatkan Arah'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
