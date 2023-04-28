import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';

const String backgroundImagePath = 'assets/images/black_background.jpeg';
const backgroundDecoration = BoxDecoration(
  image: DecorationImage(
      image: AssetImage(backgroundImagePath), fit: BoxFit.cover),
);

NiceButtons genericNiceButton({
  required BuildContext context,
  required String text,
  required Function funtion,
}) {
  return NiceButtons(
    stretch: false,
    startColor: Colors.purple,
    endColor: Colors.purple.shade800,
    borderColor: Colors.purple.shade900,
    onTap: funtion,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
