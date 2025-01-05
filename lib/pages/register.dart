import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/components/inputText.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/hive/userData.dart';
// import 'package:ka_inventory/hive/userData.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // reference box
  // final dataBox = Hive.box('kainventory');
  // userDataBox = await Hive.openBox<UserData>('userDataBox');
  // final userBox = Hive.box('userDataBox');

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
              const Text('Register',
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
              const SizedBox(height: 16),
              InputText(
                controller: _confirmPasswordController,
                label: 'confirm password',
                isPassword: true,
                passController: _passwordController,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle registration logic here

                      // check if existing user
                      if (userDataBox.get(_usernameController.text) != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Username already exists')));
                      } else {
                        setState(() {
                          userDataBox.put(
                              _usernameController.text,
                              UserData(
                                uname: _usernameController.text,
                                password: _passwordController.text,
                                prepList: [],
                                merchList: [],
                              ));
                        });
                        _usernameController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Registered successfully')));

                        Navigator.pop(context);
                      }
                      // add user to box

                      // Navigator.pushNamed(context, '/login');
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
                    'Register',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 16,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Already signed in? ',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'Login here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigator.pushNamed(context, '/login');
                            Navigator.pop(context);
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
