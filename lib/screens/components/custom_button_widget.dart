import 'package:flutter/material.dart';
import '../../style.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({Key? key, required this.text, required this.onPressed, this.enabled = true}) : super(key: key);

  final onPressed;
  final bool enabled;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      child: Center(
          child: Text(text, style: TextStyle(
            fontSize: 14,
            height: 20/14,
            letterSpacing: 0.1,
            color: enabled ? onPrimaryColor : primaryFontColor,
            fontWeight: FontWeight.w500
          ))
      ),
    );
  }
}
