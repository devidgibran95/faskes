import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/dashboard.dart';
import 'package:faskes/providers/user_provider.dart';
import 'package:faskes/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:provider/provider.dart';

import '../component/buttons.dart';
import '../component/text_field.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confrimPasswordTextController = TextEditingController();

  bool isLoading = false;

  signUp() {
    final email = emailTextController.text.trim();
    final name = nameTextController.text.trim();
    final address = addressTextController.text.trim();
    final phone = phoneTextController.text.trim();
    final password = passwordTextController.text.trim();
    final confrimPassword = confrimPasswordTextController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confrimPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field tidak boleh kosong'),
        ),
      );
    } else if (password != confrimPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi dan konfirmasi kata sandi tidak sama'),
        ),
      );
    } else {
      UserModel user = UserModel(
        email: email,
        name: name,
        address: address,
        phone: phone,
        password: password,
        role: "user",
      );

      try {
        UserService().signUp(user).then((value) {
          if (value != null) {
            setState(() {
              isLoading = false;
            });

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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membuat akun'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    'Buat Akun Baru',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  //email textfield
                  MyTextField(
                    controller: nameTextController,
                    hintText: 'Nama',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: addressTextController,
                    hintText: 'Alamat',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: phoneTextController,
                    hintText: 'Nomor Telepon',
                    keyboardType: TextInputType.phone,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  //password textfield
                  MyTextField(
                    controller: passwordTextController,
                    hintText: 'Kata Sandi',
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  //confrim password textfield
                  MyTextField(
                    controller: confrimPasswordTextController,
                    hintText: 'Konfirmasi Kata Sandi',
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  //sign in button
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blue,
                        )
                      : SizedBox(
                          //SizedBox(
                          height: 50,
                          child: GFButton(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });

                                signUp();
                              },
                              color: Colors.blue,
                              fullWidthButton: true,
                              text: 'Daftar'),
                        ),

                  const SizedBox(height: 25),

                  //go to registerpage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Masuk sekarang',
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
