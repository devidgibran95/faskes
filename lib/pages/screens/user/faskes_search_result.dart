import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/pages/screens/faskes_detail.dart';
import 'package:faskes/pages/screens/widgets/faskes_card_widget.dart';
import 'package:flutter/material.dart';
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
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? _currentP;

  final Map<String, Marker> _markers = {};

  List<FaskesModel>? faskes;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
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
        .get()
        .then((value) =>
            value.docs.map((e) => FaskesModel.fromJson(e.data())).toList());

    List<FaskesModel> searchResult = [];

    for (final f in rawSc) {
      if (f.name!.toLowerCase().contains(widget.query!.toLowerCase())) {
        searchResult.add(f);
      }
    }

    setState(() {
      faskes = searchResult;
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
                  height: MediaQuery.of(context).size.height * 0.9,
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
}
