// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/screens/widgets/front_faskes_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class NearbyFaskes extends StatefulWidget {
  LocationData? userLocation;

  NearbyFaskes({required this.userLocation, super.key});

  @override
  State<NearbyFaskes> createState() => _NearbyFaskesState();
}

class _NearbyFaskesState extends State<NearbyFaskes> {
  // calcualte faskes latitude and longitude to user latitude and longitude
  // then calculate the distance
  List<FaskesModel> calculateDistance(List<FaskesModel> nearbyFaskes) {
    List tempFaskesDistances = [];

    List<FaskesModel> faskes = [];

    for (var i = 0; i < nearbyFaskes.length; i++) {
      var fask = nearbyFaskes[i];
      var distance = calculateDistanceInKilometers(
          widget.userLocation!.latitude!,
          widget.userLocation!.longitude!,
          fask.latitude!,
          fask.longitude!);

      // if distance is less than 10 km, add to faskes list
      print(fask.name! + ": " + distance.toString());
      if (distance <= 20) {
        tempFaskesDistances.add(
          {
            'faskesId': fask.id!,
            'distance': distance,
          },
        );
      }
    }

    // sort tempFaskesDistances map by value ascending
    tempFaskesDistances.sort((a, b) => a['distance'].compareTo(b['distance']));

    // add tempFaskesDistnaces to faskes
    for (var i = 0; i < tempFaskesDistances.length; i++) {
      var faskesId = tempFaskesDistances[i]['faskesId'];

      var f = nearbyFaskes.firstWhere((element) => element.id == faskesId);

      faskes.add(f);
    }

    return faskes;
  }

  calculateDistanceInKilometers(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("faskes").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FaskesModel> catList = snapshot.data!.docs
                .map((e) => FaskesModel.fromJson(e.data()))
                .toList();

            // sort faskes by distance to user location
            List<FaskesModel> sortedFaskes = calculateDistance(catList);

            return ListView.builder(
                itemCount: sortedFaskes.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var fask = sortedFaskes[index];

                  return FrontFaskesCardWidget(
                    faskes: fask,
                    userLocation: widget.userLocation,
                  );
                });
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
