import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ka_inventory/components/login/loginForm.dart';
import 'package:ka_inventory/components/login/registerForm.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Image.asset('assets/img/logo.png', height: 250),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    isLogin ? Loginform() : Registerform(),
                    RichText(
                        text: TextSpan(
                            text: isLogin
                                ? 'Don\'t have an account? '
                                : 'Already have an account? ',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                            children: <TextSpan>[
                          TextSpan(
                              text: isLogin ? 'Register here' : 'Login here',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff48545C),
                                  decoration: TextDecoration.underline))
                        ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
