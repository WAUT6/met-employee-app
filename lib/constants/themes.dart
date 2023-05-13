import 'package:flutter/material.dart';

const String backgroundImagePath = 'assets/images/black_background.jpeg';
const backgroundDecoration = BoxDecoration(
  image: DecorationImage(
      image: AssetImage(backgroundImagePath), fit: BoxFit.cover),
);

const fallBackImage =
    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

