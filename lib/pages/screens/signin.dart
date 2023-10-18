import 'package:faskes/pages/component/buttons.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/pages/screens/dashboard.dart';
import 'package:faskes/providers/user_provider.dart';
import 'package:faskes/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool isObscure = true;

  bool isLoading = false;

  Key _formKey = GlobalKey<FormState>();

  signIn() {
    final email = emailTextController.text.trim();
    final password = passwordTextController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan Password tidak boleh kosong'),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });

      UserService().signIn(email, password).then((value) {
        setState(() {
          isLoading = false;
        });

        if (value != null) {
          Provider.of<UserProvider>(context, listen: false).user = (value);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Dashboard(
                user: value,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //LOGO
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 50),
                  //Welcomeback messages
                  const Text(
                    'Selamat Datang Kembali!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  //create a form for login with email and password
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //email textfield
                        MyTextField(
                          controller: emailTextController,
                          hintText: 'Email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 15),

                        //password textfield
                        MyTextField(
                          controller: passwordTextController,
                          hintText: 'Password',
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //sign in button
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blue,
                        )
                      : SizedBox(
                          height: 50,
                          child: GFButton(
                              onPressed: () {
                                signIn();
                              },
                              color: Colors.blue,
                              fullWidthButton: true,
                              text: 'Masuk'),
                        ),

                  // create a button to sign in with google

                  const SizedBox(height: 25),

                  //go to registerpage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
