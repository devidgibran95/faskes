import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/pages/screens/faskes_detail.dart';
import 'package:flutter/material.dart';

class FaskesCardWidget extends StatefulWidget {
  FaskesModel faskes;
  FaskesCardWidget({required this.faskes, super.key});

  @override
  State<FaskesCardWidget> createState() => _FaskesCardWidgetState();
}

class _FaskesCardWidgetState extends State<FaskesCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FaskesDetail(
              faskes: widget.faskes,
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.faskes.imageUrl == "-"
                ?
                // create container that says no image found
                Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        "No Image Found",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      widget.faskes.imageUrl!,
                      fit: BoxFit.cover,
                    )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //create a name text for title
                  Text(
                    widget.faskes.name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //create a description text for subtitle
                  Text(
                    widget.faskes.address!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
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
