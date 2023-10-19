import 'dart:math';

import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/rating_model.dart';
import 'package:faskes/pages/screens/faskes_detail.dart';
import 'package:faskes/pages/utils/styles.dart';
import 'package:faskes/services/rating_service.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FrontFaskesCardWidget extends StatefulWidget {
  FaskesModel faskes;
  LocationData? userLocation;

  FrontFaskesCardWidget({
    required this.faskes,
    required this.userLocation,
    super.key,
  });

  @override
  State<FrontFaskesCardWidget> createState() => _FrontFaskesCardWidgetState();
}

class _FrontFaskesCardWidgetState extends State<FrontFaskesCardWidget> {
  double ratingValue = 0;
  double? distance = 0;

  @override
  void initState() {
    setRating();
    setDistance();
    super.initState();
  }

  setDistance() {
    double tempDistance = calculateDistanceInKilometers(
        widget.userLocation!.latitude!,
        widget.userLocation!.longitude!,
        widget.faskes.latitude!,
        widget.faskes.longitude!);

    // round distance
    tempDistance = double.parse(tempDistance.toStringAsFixed(2));

    setState(() {
      distance = tempDistance;
    });
  }

  calculateDistanceInKilometers(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }

  setRating() async {
    List<RatingModel> ratings =
        await RatingService().getFaskesRatings(widget.faskes.id!);

    double tempAvg = RatingService().getRatingAverage(ratings);

    setState(() {
      ratingValue = tempAvg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: FaskesDetail(
            faskes: widget.faskes,
          ),
          withNavBar: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: black,
          borderRadius: BorderRadius.circular(26),
          image: DecorationImage(
            image: NetworkImage(widget.faskes.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
        height: 250,
        width: 250,
        margin: EdgeInsets.only(right: medium),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 0, 0.75),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: small, bottom: medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ancentlight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: 68,
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                size: 17, color: Colors.yellow),
                            Text(
                              ratingValue == 0 || ratingValue.isNaN
                                  ? "-"
                                  : ratingValue.toString(),
                              style: rating,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.faskes.name!, style: pBold),
                    const SizedBox(height: 5),
                    Text(widget.faskes.address!, style: pLocation),
                    const SizedBox(height: 10),
                    distance == 0
                        ? const SizedBox.shrink()
                        : Text("$distance km",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
