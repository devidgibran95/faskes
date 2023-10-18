import 'package:faskes/pages/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:faskes/pages/utils/styles.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //LOGO
          Padding(
            padding: const EdgeInsets.only(
              left: 80.0,
              right: 80.0,
              bottom: 40.0,
              top: 145.0,
            ),
            child: Image.asset('assets/images/welcomepage.png'),
          ),
          //Dekat Jauh Tidak Masalah, Temukan Semua di Sini!
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Dekat Jauh Tidak Masalah, Temukan Semua di Sini!',
              style: welcome,
              textAlign: TextAlign.center,
            ),
          ),
          //Semua Fasilitas dalam Genggaman Anda!\
          Text(
            'Fasilitas kesehatan dalam genggaman Anda!',
            style: heading4,
            textAlign: TextAlign.center,
          ),

          const Spacer(),
          //Get Started

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const LoginOrRegister();
                  },
                ));
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ancent,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Mulai',
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            ),
          ),

          const Spacer()
        ],
      ),
    );
  }
}
