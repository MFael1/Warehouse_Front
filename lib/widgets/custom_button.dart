import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_web_dashboard/constants/style.dart';

class customButton extends StatelessWidget {
  final VoidCallback onPress;
  final String buttontext;

  const customButton(
      {super.key, required this.onPress, required this.buttontext});

  final CustomTextButton = const TextStyle(
    fontSize: 20, // Font size
    fontWeight: FontWeight.bold, // Font weight
    color: Colors.white, // Text color
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPress: onPress,
      height: 30,
      width: 70,
      text: buttontext,
      isReverse: true,
      selectedTextColor: Color.fromARGB(184, 19, 141, 255),
      transitionType: TransitionType.RIGHT_CENTER_ROUNDER,
      textStyle: CustomTextButton,
      backgroundColor: Color.fromARGB(255, 43, 59, 227),
      borderColor: Color.fromARGB(255, 255, 255, 255),
      borderWidth: 1,
    );
  }
}
