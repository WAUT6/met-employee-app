import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:metapp/bloc/chat_bloc/chat_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';

import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/chat/chat_provider.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/views/chat_views/chat_view.dart';
import 'package:metapp/views/chat_views/favorite_users_list_view.dart';
import 'package:metapp/views/chat_views/users_list_view.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
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
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(ChatProvider()),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          'Favorite Users',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<Iterable<ChatUser>>(
                      stream: cloudStorage.allFavoriteUsers(
                        userId: currentUserId,
                      ),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text(
                                  'No favorite users yet',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34,
                                  ),
                                ),
                              );
                            } else {
                              final Iterable<ChatUser> allFavoriteUsers =
                                  snapshot.data as Iterable<ChatUser>;
                              return Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.black,
                                  ),
                                  child: FavoriteUsersListView(
                                    onTap: (user) {
                                      context.read<ChatBloc>().add(
                                            ChatEventWantToMessageUser(
                                              receivingUser: user,
                                              userId: currentUserId,
                                            ),
                                          );

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context.read<ChatBloc>(),
                                            child: const ChatView(),
                                          ),
                                        ),
                                      );
                                    },
                                    currentUserId: currentUserId,
                                    users: allFavoriteUsers,
                                  ),
                                ),
                              );
                            }
                          default:
                            return const Center(
                              child: Text(
                                'No favorite users yet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34,
                                ),
                              ),
                            );
                        }
                      },
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
                            return UsersListView(
                              currentUserId: currentUserId,
                              users: allUsers,
                              onTapHeart: (user) {},
                              onTapTile: (user) {
                                context.read<ChatBloc>().add(
                                      ChatEventWantToMessageUser(
                                        receivingUser: user,
                                        userId: currentUserId,
                                      ),
                                    );

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ChatBloc>(),
                                      child: const ChatView(),
                                    ),
                                  ),
                                );
                              },
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
        ));
  }
}
