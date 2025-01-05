import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ka_inventory/components/inputText.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/hive/userData.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              InputText(
                controller: _usernameController,
                label: 'username',
              ),
              const SizedBox(height: 16),
              InputText(
                controller: _passwordController,
                label: 'password',
                isPassword: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle registration logic here

                      // check if user exists
                      if (userDataBox.get(_usernameController.text) != null) {
                        UserData userData =
                            userDataBox.get(_usernameController.text);

                        // check password
                        if (userData.password == _passwordController.text) {
                          userKey = _usernameController.text;
                          Navigator.pushNamed(context, '/menu');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Password does not match')));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User not found')));
                      }
                    }
                  },
                  style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(0),
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff48545C)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 16,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'Register here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
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
    );
  }
}
