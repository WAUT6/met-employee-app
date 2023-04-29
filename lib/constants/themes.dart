import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';

const String backgroundImagePath = 'assets/images/black_background.jpeg';
const backgroundDecoration = BoxDecoration(
  image: DecorationImage(
      image: AssetImage(backgroundImagePath), fit: BoxFit.cover),
);

const fallBackImage =
    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

NiceButtons genericNiceButton({
  required BuildContext context,
  required String text,
  required Function funtion,
}) {
  return NiceButtons(
    borderRadius: 30,
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
