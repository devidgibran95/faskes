// ignore_for_file: unused_local_variable
import 'package:faskes/pages/models/cardtop.dart';
import 'package:flutter/material.dart';
import 'card_top.dart';

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    List<Categorytop> categorytops = [
      Categorytop('assets/images/hospital.png', 'Hospital', 'rumahsakit'),
      Categorytop('assets/images/klinik.png', 'Clinic', 'klinik'),
      Categorytop('assets/images/puskesmas.png', 'Puskesmas', 'puskesmas'),
      Categorytop('assets/images/apotek.png', 'Apotek', 'apotek'),
    ];
    return SizedBox(
      height: 75,
      child: ListView.builder(
          itemCount: categorytops.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var cat = categorytops[index];
            return CardTop(name: cat.name, image: cat.image, indo: cat.indo);
          }),
    );
  }
}
