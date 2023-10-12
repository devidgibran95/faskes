import 'package:flutter/material.dart';

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
  final passwordTextController = TextEditingController();
  final confrimPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //LOGO
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                //Welcomeback messages
                Text('Mari buat Akun untuk Kamu',
                    style: TextStyle(color: Colors.grey.shade700)),

                const SizedBox(height: 25),

                //email textfield
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                //password textfield
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //confrim password textfield
                MyTextField(
                  controller: confrimPasswordTextController,
                  hintText: 'Confrim Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign in button
                MyButton(
                  onTap: () {},
                  text: 'Sign Up ',
                ),

                const SizedBox(height: 25),

                //go to registerpage
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
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
    );
  }
}
