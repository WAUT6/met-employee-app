import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metapp/bloc/chat_bloc/chat_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/bloc/chat_bloc/chat_states.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/views/chat_views/chat_list_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController controller;
  late final FirebaseCloudStorage _cloudStorage;
  final int _limit = 70;
  String groupChatId = '';
  String userId = '';
  String receivingUserId = '';
  File? imageFile;
  @override
  void initState() {
    controller = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget messageInputField(
      {required BuildContext context,
      required TextEditingController controller}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                context.read<ChatBloc>().add(
                      ChatEventSendTextMessage(
                        controller: controller,
                        userId: userId,
                        receivingUserId: receivingUserId,
                        groupId: groupChatId,
                      ),
                    );
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              controller: controller,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              autofocus: true,
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 1,
              ),
              child: IconButton(
                onPressed: getImage,
                icon: const Icon(Icons.image),
                color: Colors.purple,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                onPressed: () => context.read<ChatBloc>().add(
                      ChatEventSendTextMessage(
                        controller: controller,
                        userId: userId,
                        receivingUserId: receivingUserId,
                        groupId: groupChatId,
                      ),
                    ),
                icon: const Icon(Icons.send),
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery).catchError(
      (e) {
        Fluttertoast.showToast(msg: 'Invalid image');
        return null;
      },
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        uploadFile();
      }
    }
  }

  Future<void> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<ChatBloc>().add(
          ChatEventUploadFile(
            fileName: fileName,
            imageFile: imageFile!,
            groupId: groupChatId,
            userId: userId,
            receivingUserId: receivingUserId,
          ),
        );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: context.read<ChatBloc>(),
      builder: (context, state) {
        if (state is ChatStateMessagingUser) {
          userId = state.userId;
          receivingUserId = state.receivingUser.id;
          groupChatId = '$userId-$receivingUserId';
          return Scaffold(
            appBar: AppBar(
              title: Text('Messaging ${state.receivingUser.nickname}'),
              centerTitle: true,
            ),
            body: WillPopScope(
              onWillPop: () {
                context
                    .read<ChatBloc>()
                    .add(const ChatEventWantToViewUsersPage());
                return Future.value(true);
              },
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: _cloudStorage.allMessages(
                        _limit,
                        groupChatId,
                      ),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (!snapshot.hasData) {
                              return Scaffold(
                                body: Container(
                                  decoration: backgroundDecoration,
                                  child: Column(
                                    children: [
                                      const Center(
                                        child: Text('No messages yet'),
                                      ),
                                      messageInputField(
                                          context: context,
                                          controller: controller),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              final messageList =
                                  snapshot.data as Iterable<ChatMessage>;
                              return Container(
                                decoration: backgroundDecoration,
                                child: Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    ChatListView(
                                      messageList: messageList,
                                      userId: state.userId,
                                      peerId: state.receivingUser.id,
                                    ),
                                    messageInputField(
                                      context: context,
                                      controller: controller,
                                    ),
                                  ],
                                ),
                              );
                            }
                          default:
                            return Scaffold(
                              body: Container(
                                decoration: backgroundDecoration,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Container(
              decoration: backgroundDecoration,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
