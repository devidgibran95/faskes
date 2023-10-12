// ignore_for_file: unused_local_variable

import 'package:faskes/pages/component/card_faskes.dart';
import 'package:faskes/pages/models/cardfaskes.dart';
import 'package:flutter/material.dart';

class FaskesTerdekat extends StatelessWidget {
  const FaskesTerdekat({super.key});

  @override
  Widget build(BuildContext context) {
    List<Nearbyfaskes> nearbyfaskess = [
      Nearbyfaskes('assets/images/puskesmasmulyorejo.jpg',
          'Puskesmas Mulyorejo', '3.5', 'Jl. Raya Mulyorejo No.11A'),
      Nearbyfaskes('assets/images/viva2.jpg', 'Viva Apotek', '4.5',
          'Jl. Bandulan No.78'),
      Nearbyfaskes('assets/images/mergan.jpg', 'Apotek Mergan', '5.0',
          'Jl. Jupri Jl. Mergan Raya No.627 D'),
      Nearbyfaskes('assets/images/beuty.jpg', 'Beauty Skin Care', '5.0',
          'Jl. Raya Langsep No.42, Bareng'),
    ];
    return SizedBox(
      height: 250,
      child: ListView.builder(
          itemCount: nearbyfaskess.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var fask = nearbyfaskess[index];

            return CardFaskes(
                image: fask.image,
                name: fask.name,
                rating1: fask.rating1,
                location: fask.location);
          }),
    );
  }
}
