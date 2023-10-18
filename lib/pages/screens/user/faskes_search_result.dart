import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/pages/screens/faskes_detail.dart';
import 'package:faskes/pages/screens/widgets/faskes_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FaskesSearchResult extends StatefulWidget {
  String? query;
  LocationData locationData;
  FaskesSearchResult(
      {required this.query, required this.locationData, super.key});

  @override
  State<FaskesSearchResult> createState() => _FaskesSearchResultState();
}

class _FaskesSearchResultState extends State<FaskesSearchResult> {
  Location _locationController = new Location();
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _pCyberPlex =
      LatLng(-7.973423077691103, 112.61298281822337);
  static const LatLng _pBandulanPlex =
      LatLng(-7.980564799884812, 112.6094458248418);
  LatLng? _currentP;

  final Map<String, Marker> _markers = {};

  List<FaskesModel>? faskes;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    getLocationUpdates();
    setInitialData();

    super.initState();
  }

  setInitialData() {
    setState(() {
      controller.text = widget.query!;
      _currentP =
          LatLng(widget.locationData.latitude!, widget.locationData.longitude!);
    });
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;

    var location = Location();

    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    List<FaskesModel> rawSc = await FirebaseFirestore.instance
        .collection('faskes')
        .where('name', isGreaterThanOrEqualTo: widget.query)
        .where('name', isLessThanOrEqualTo: '${widget.query!}\uf8ff')
        .get()
        .then((value) =>
            value.docs.map((e) => FaskesModel.fromJson(e.data())).toList());

    setState(() {
      faskes = rawSc;
    });

    _markers.clear();

    for (final f in faskes!) {
      final marker = Marker(
        markerId: MarkerId(f.name!),
        position: LatLng(f.latitude!, f.longitude!),
        infoWindow: InfoWindow(
            title: f.name,
            snippet: f.address,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FaskesDetail(
                    faskes: f,
                  ),
                ),
              );
            }),
      );

      _markers[f.name!] = marker;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.list),
        label: const Text("Lihat Daftar Faskses"),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: ListView.builder(
                      itemCount: faskes!.length,
                      itemBuilder: (context, index) {
                        return FaskesCardWidget(faskes: faskes![index]);
                      },
                    ),
                  ),
                );
              });
        },
      ),
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                _currentP!.latitude, _currentP!.longitude),
                            zoom: 13.0,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          markers: _markers.values.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);

                            _onMapCreated(controller);
                          },
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                    ],
                  ),
                  SafeArea(
                    child: Card(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: MyTextField(
                                      keyboardType: TextInputType.text,
                                      controller: controller,
                                      hintText: "Masukan nama faskes",
                                      obscureText: false),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search)),
                              IconButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    _currentLocation();
                                  },
                                  icon: const Icon(Icons.my_location)),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionnGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionnGranted = await _locationController.hasPermission();
    if (_permissionnGranted == PermissionStatus.denied) {
      _permissionnGranted = await _locationController.requestPermission();
      if (_permissionnGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentP);
        });
      }
    });
  }
}
