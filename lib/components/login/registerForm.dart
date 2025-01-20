import 'package:flutter/material.dart';
import 'package:ka_inventory/components/inputText.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/hive/userData.dart';

class Registerform extends StatelessWidget {
  const Registerform({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    return Form(
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Username already exists')));
                  } else {
                    userDataBox.put(
                        _usernameController.text,
                        UserData(
                            uname: _usernameController.text,
                            password: _passwordController.text,
                            prepList: [],
                            merchList: [],
                            orderList: [],
                            transactionList: []));

                    userKey = _usernameController.text;

                    _usernameController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();

                    Navigator.pushNamed(context, '/menu');
                  }
                }
              },
              style: const ButtonStyle(
                  elevation: WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(Color(0xff48545C)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
