import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/services/chat/chat_provider.dart';

import '../bloc/chat_bloc/chat_bloc.dart';
import '../services/chat/chat_user.dart';
import '../services/cloud/firebase/firebase_cloud_storage.dart';

class HeartWidget extends StatefulWidget {
  final String currentUserId;
  final ChatUser favoriteUser;
  const HeartWidget({
    super.key,
    required this.currentUserId,
    required this.favoriteUser,
  });

  @override
  State<HeartWidget> createState() => _HeartWidgetState();
}

class _HeartWidgetState extends State<HeartWidget> {
  late final FirebaseCloudStorage _cloudStorage;
  bool isFavorited = false;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    Future.delayed(
      Duration.zero,
      () async {
        final isFav = await _cloudStorage.checkIfUserInFavorites(
          userId: widget.favoriteUser.id,
          currentUserId: widget.currentUserId,
        );
        setState(() {
          isFavorited = isFav;
        });
      },
    );
    super.initState();
  }

  void _toggleFavorite(BuildContext context) {
    setState(() {
      if (isFavorited) {
        context.read<ChatBloc>().add(
              ChatEventRemoveUserFromFavorites(
                user: widget.favoriteUser,
                currentUserId: widget.currentUserId,
              ),
            );
        isFavorited = false;
      } else {
        context.read<ChatBloc>().add(
              ChatEventAddUserToFavorites(
                user: widget.favoriteUser,
                currentUserId: widget.currentUserId,
              ),
            );
        isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(ChatProvider()),
      child: IconButton(
        onPressed: () => _toggleFavorite(context),
        icon: isFavorited
            ? const Image(
                color: Colors.red,
                image: AssetImage(
                  'assets/images/red_heart.png',
                ),
              )
            : const Image(
                color: Colors.white,
                image: AssetImage(
                  'assets/images/heart.png',
                ),
              ),
      ),
    );
  }
}
