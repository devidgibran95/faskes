import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/dashboard.dart';
import 'package:faskes/pages/screens/welcome.dart';
import 'package:faskes/providers/user_provider.dart';
import 'package:faskes/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  Timer? _timer;

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _startDelay();

    //checkIfSignedIn();
    super.initState();
  }

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _decideNext);
  }

  Future<void> _decideNext() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        final userData = value.data() as Map<String, dynamic>;
        final userModel = UserModel.fromJson(userData);

        Provider.of<UserProvider>(context, listen: false).user = userModel;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Dashboard(user: userModel),
          ),
        );
      });
    } else {
      // navigate to welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Welcome(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 30),
            const Text(
              'WE CARE',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
