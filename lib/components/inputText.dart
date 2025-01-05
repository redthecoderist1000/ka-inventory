import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController? passController;
  final String label;
  final bool? isPassword;
  final String? Function(String?)? validator;

  const InputText(
      {super.key,
      required this.controller,
      required this.label,
      this.passController,
      this.isPassword,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 172, 189, 200)),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xff48545C))),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff48545C)),
        ),
        fillColor: const Color(0xff48545C),
        filled: true,

        // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      obscureText: isPassword ?? false,
      obscuringCharacter: '*',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        } else {
          if (isPassword == true && passController == null) {
            if (controller.text.length < 8) {
              return 'Password must contain 8 characters or more';
            }
          }
          if (passController != null) {
            // confirm pass to
            if (value != passController?.text) {
              return "Password do not match";
            }
          }
        }
        return null;
      },
    );
  }
}
