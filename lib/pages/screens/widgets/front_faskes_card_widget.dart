import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/screens/faskes_detail.dart';
import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FrontFaskesCardWidget extends StatefulWidget {
  FaskesModel faskes;

  FrontFaskesCardWidget({
    required this.faskes,
    super.key,
  });

  @override
  State<FrontFaskesCardWidget> createState() => _FrontFaskesCardWidgetState();
}

class _FrontFaskesCardWidgetState extends State<FrontFaskesCardWidget> {
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
        width: 200,
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
                              "-",
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
                  children: [
                    Text(widget.faskes.name!, style: pBold),
                    Text(widget.faskes.address!, style: pLocation),
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
