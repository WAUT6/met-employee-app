import 'package:flutter/material.dart';

typedef RedHeartIconOnTapCallBack = void Function();

Widget buildRedHeartIcon({
  required RedHeartIconOnTapCallBack callBack,
}) {
  return IconButton(
    splashColor: Colors.red,
    onPressed: () => callBack(),
    icon: const Image(
      color: Colors.red,
      image: AssetImage(
        'assets/images/red_heart.png',
      ),
    ),
  );
}
