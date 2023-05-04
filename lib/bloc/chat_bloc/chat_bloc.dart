import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/bloc/chat_bloc/chat_states.dart';
import 'package:metapp/services/chat/chat_constants.dart';
import 'package:metapp/services/chat/chat_provider.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatProvider provider) : super(const ChatStateViewingUsersPage()) {
    on<ChatEventWantToMessageUser>(
      (event, emit) {
        emit(
          ChatStateMessagingUser(
            receivingUser: event.receivingUser,
            userId: event.userId,
          ),
        );
      },
    );

    on<ChatEventSendTextMessage>(
      (event, emit) {
        if (event.controller.text.isNotEmpty) {
          final message = event.controller.text.trim();
          provider.sendMessage(
            message,
            event.userId,
            event.receivingUserId,
            event.groupId,
            ChatMessageType.text,
          );
          event.controller.clear();
        } else {
          Fluttertoast.showToast(
            msg: 'Nothing to send',
            backgroundColor: Colors.grey,
          );
        }
      },
    );

    on<ChatEventUploadFile>(
      (event, emit) async {
        UploadTask uploadTask = provider.uploadFile(
          event.imageFile,
          event.fileName,
        );
        try {
          TaskSnapshot snapshot = await uploadTask;
          String imageUrl = await snapshot.ref.getDownloadURL();
          provider.sendMessage(
            imageUrl,
            event.userId,
            event.receivingUserId,
            event.groupId,
            ChatMessageType.image,
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'Could Not Upload File');
        }
      },
    );

    on<ChatEventWantToViewUsersPage>(
      (event, emit) {
        emit(const ChatStateViewingUsersPage());
      },
    );

    // on<ChatEventInitialize>(
    //   (event, emit) async {
    //     await chatProvider.initializeChatProvider();
    //   },
    // );
  }
}
