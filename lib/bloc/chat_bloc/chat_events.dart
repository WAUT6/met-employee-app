import 'dart:io';

import 'package:flutter/material.dart';
import 'package:metapp/services/chat/chat_user.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatEventWantToViewUsersPage extends ChatEvent {
  const ChatEventWantToViewUsersPage();
}

class ChatEventWantToMessageUser extends ChatEvent {
  final ChatUser receivingUser;
  final String userId;

  const ChatEventWantToMessageUser({
    required this.receivingUser,
    required this.userId,
  });
}

class ChatEventSendTextMessage extends ChatEvent {
  final TextEditingController controller;
  final String userId;
  final String receivingUserId;
  final String groupId;

  const ChatEventSendTextMessage({
    required this.controller,
    required this.userId,
    required this.receivingUserId,
    required this.groupId,
  });
}

class ChatEventUploadFile extends ChatEvent {
  final File imageFile;
  final String fileName;
  final String userId;
  final String receivingUserId;
  final String groupId;

  const ChatEventUploadFile({
    required this.imageFile,
    required this.fileName,
    required this.groupId,
    required this.userId,
    required this.receivingUserId,
  });
}

class ChatEventCheckCurrentUserInCollection extends ChatEvent {
  final String receivingUserId;
  ChatEventCheckCurrentUserInCollection({
    required this.receivingUserId,
  });
}

class ChatEventInitialize extends ChatEvent {
  const ChatEventInitialize();
}

class ChatEventAddUserToFavorites extends ChatEvent {
  final ChatUser user;
  final String currentUserId;

  const ChatEventAddUserToFavorites({
    required this.user,
    required this.currentUserId,
  });
}

class ChatEventRemoveUserFromFavorites extends ChatEvent {
  final ChatUser user;
  final String currentUserId;

  const ChatEventRemoveUserFromFavorites({
    required this.user,
    required this.currentUserId,
  });
}
