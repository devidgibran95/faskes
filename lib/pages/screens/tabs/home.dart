import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/category_model.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/region_model.dart';
import 'package:faskes/models/type_model.dart';
import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/widgets/category_card_widget.dart';
import 'package:faskes/pages/screens/user/nearby_faskes.dart';
import 'package:faskes/pages/component/labelsection.dart';
import 'package:faskes/pages/screens/user/search_faskes.dart';
import 'package:faskes/pages/screens/admin/faskes_list.dart';
import 'package:faskes/pages/screens/admin/faskes_categories.dart';
import 'package:faskes/pages/screens/admin/faskes_regions.dart';
import 'package:faskes/pages/screens/admin/faskes_types.dart';
import 'package:faskes/pages/screens/admin/users_list.dart';
import 'package:faskes/pages/utils/styles.dart';
import 'package:faskes/providers/user_provider.dart';
import 'package:faskes/services/category_service.dart';
import 'package:faskes/services/faskes_service.dart';
import 'package:faskes/services/region_service.dart';
import 'package:faskes/services/type_service.dart';
import 'package:faskes/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen({required this.user, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? userTotal, faskesTotal, regionTotal, categoryTotal, typeTotal;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationData? _userLocation;

  @override
  void initState() {
    widget.user.role == "user" ? _getUserLocation() : getCountData();

    super.initState();
  }

  // This function will get user location
  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    setState(() {
      _userLocation = locationData;
    });
  }

  getCountData() {
    try {
      UserService().getUserCount().then((value) {
        setState(() {
          userTotal = value;
        });

        FaskesService().getFaskesCount().then((value) {
          setState(() {
            faskesTotal = value;
          });

          RegionService().getRegionCount().then((value) {
            setState(() {
              regionTotal = value;
            });

            CategoryService().getCategoryCount().then((value) {
              setState(() {
                categoryTotal = value;
              });

              TypeService().getTypeCount().then((value) {
                setState(() {
                  typeTotal = value;
                });
              });
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  buildHeader(UserProvider user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 50, 30, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // gf avatar with network image
              GFAvatar(
                backgroundImage: NetworkImage(user.user!.image ??
                    "https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-and-shapes-3/177800/130-512.png"),
                shape: GFAvatarShape.circle,
                radius: 30,
              ),
              SizedBox(width: small),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: p1,
                  ),
                  Text(
                    user.user!.name!,
                    style: heading3,
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  buildAdminView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const UsersList(),
                withNavBar: false,
              );
            },
            child: GFCard(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // convert snapshot data to list of category model
                        final List<UserModel> catList = snapshot.data!.docs
                            .map((e) => UserModel.fromJson(e.data()))
                            .toList();

                        catList
                            .removeWhere((element) => element.role == "admin");

                        return Text(
                          catList.length.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Pengguna"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const FaskesList(),
                withNavBar: false,
              );
            },
            child: GFCard(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("faskes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // convert snapshot data to list of category model
                        final List<FaskesModel> list = snapshot.data!.docs
                            .map((e) => FaskesModel.fromJson(e.data()))
                            .toList();

                        return Text(
                          list.length.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text("Fasilitas Kesehatan"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const FaskesRegions(),
                withNavBar: false,
              );
            },
            child: GFCard(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("regions")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // convert snapshot data to list of category model
                        final List<RegionModel> list = snapshot.data!.docs
                            .map((e) => RegionModel.fromJson(e.data()))
                            .toList();

                        return Text(
                          list.length.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Wilayah"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const FaskesCategories(),
                withNavBar: false,
              );
            },
            child: GFCard(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("categories")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // convert snapshot data to list of category model
                        final List<CategoryModel> list = snapshot.data!.docs
                            .map((e) => CategoryModel.fromJson(e.data()))
                            .toList();

                        return Text(
                          list.length.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Kategori Faskes"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const FaskesTypes(),
                withNavBar: false,
              );
            },
            child: GFCard(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("types")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // convert snapshot data to list of category model
                        final List<TypeModel> list = snapshot.data!.docs
                            .map((e) => TypeModel.fromJson(e.data()))
                            .toList();

                        return Text(
                          list.length.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Jenis Faskes"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildUserView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Column(
        children: [
          _userLocation == null
              ? const SizedBox.shrink()
              : SearchSection(
                  locationData: _userLocation!,
                ),
          SizedBox(height: medium),
          LabelSection(
            text: 'Fasilitas terdekat',
            style: heading1,
          ),
          const SizedBox(height: 15),
          _userLocation == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : NearbyFaskes(
                  userLocation: _userLocation,
                ),
          SizedBox(height: medium),
          LabelSection(
            text: 'Kategori',
            style: heading1,
          ),
          const SizedBox(height: 15),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // convert snapshot data to list of category model
                  final List<CategoryModel> catList = snapshot.data!.docs
                      .map((e) => CategoryModel.fromJson(e.data()))
                      .toList();

                  return SizedBox(
                    height: 75,
                    child: ListView.builder(
                        itemCount: catList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var cat = catList[index];
                          return CategoryCardWidget(
                            category: cat,
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(user),
              SizedBox(height: small),
              user.user!.role == "admin" ? buildAdminView() : buildUserView()
            ],
          ),
        ),
      ),
    );
  }
}
