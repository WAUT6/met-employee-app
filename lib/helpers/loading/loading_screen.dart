import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metapp/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({
    required BuildContext context,
    required String textToShow,
  }) {
    if (controller?.update(textToShow) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        textData: textToShow,
      );
    }
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String textData,
  }) {
    final text = StreamController<String>();
    text.add(textData);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        text.close();
        overlay.remove();
        return true;
      },
      update: (textData) {
        text.add(textData);
        return true;
      },
    );
  }
}
