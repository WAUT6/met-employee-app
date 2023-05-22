import 'package:flutter/material.dart';

typedef EmptyHeartIconOnTapCallBack = void Function();

Widget buildEmptyHeartIcon({
  required EmptyHeartIconOnTapCallBack callBack,
}) {
  return IconButton(
    splashColor: Colors.amber,
    onPressed: () => callBack(),
    icon: const Image(
      color: Colors.white,
      image: AssetImage(
        'assets/images/heart.png',
      ),
    ),
  );
}
