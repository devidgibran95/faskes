import 'package:faskes/pages/screens/signin.dart';
import 'package:faskes/pages/screens/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool ShowLoginPage = true;

  //tooglemethodlogin and registes
  void tooglePages() {
    setState(() {
      ShowLoginPage = !ShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLoginPage) {
      return Login(onTap: tooglePages);
    } else {
      return Register(onTap: tooglePages);
    }
  }
}
