import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:metapp/bloc/chat_bloc/chat_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/bloc/io_bloc/io_bloc.dart';
import 'package:metapp/bloc/io_bloc/io_states.dart';
import 'package:metapp/bloc/share_bloc/share_bloc.dart';

import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/views/chat_views/users_list_view_with_checkbox.dart';

import '../../services/cloud/firebase/firebase_cloud_storage.dart';

class UsersViewWithCheckBox extends StatefulWidget {
  const UsersViewWithCheckBox({super.key});

  @override
  State<UsersViewWithCheckBox> createState() => _UsersViewWithCheckBoxState();
}

class _UsersViewWithCheckBoxState extends State<UsersViewWithCheckBox> {
  late final FirebaseCloudStorage cloudStorage;
  late final AuthService authService;
  late final String currentUserId;

  @override
  void initState() {
    cloudStorage = FirebaseCloudStorage();
    authService = AuthService.firebase();
    currentUserId = authService.currentUser!.id;
    super.initState();
  }

  @override
  void dispose() {
    context.read<ShareBloc>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      width: 300,
                      child: const Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                        ),
                        child: TextField(
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search For User',
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: StreamBuilder(
                      stream: context.read<ShareBloc>().selectedUsersStream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            final selectedUsers = snapshot.data ?? [];

                            return BlocBuilder<IoBloc, IoState>(
                              builder: (context, state) {
                                if (state is IoStateAwaitingUserSelection) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        disabledBackgroundColor: Colors.grey,
                                        backgroundColor: Colors.white),
                                    onPressed: selectedUsers.isEmpty
                                        ? null
                                        : () {
                                            BlocProvider.of<ChatBloc>(context)
                                                .add(
                                              ChatEventSendMessages(
                                                userId: currentUserId,
                                                receivingUsers: selectedUsers,
                                                file: state.pdf,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                    child: const Text(
                                      'Done',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: StreamBuilder<Iterable<ChatUser>>(
                  stream: cloudStorage.allUsers(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              'No users yet',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          final Iterable<ChatUser> allUsers =
                              snapshot.data as Iterable<ChatUser>;
                          // print(currentUserId);
                          return UsersListViewWithCheckBox(
                            currentUserId: currentUserId,
                            users: allUsers,
                          );
                        }
                      default:
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
