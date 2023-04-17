import 'package:flutter/material.dart';
import '../../style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, required this.name, required this.formKey, required this.controller, required this.hintText, this.validator}) : super(key: key);

  final String name;
  final formKey;
  final controller;
  final String hintText;
  final validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: smallTextStyle),
        const Padding(padding: EdgeInsets.only(bottom: 2)),
        Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: mediumTextStyle,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
            ),
            validator: validator,
            style: mediumTextStyle,
          ),
        ),
      ],
    );
  }
}
