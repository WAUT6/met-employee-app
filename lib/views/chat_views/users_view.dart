import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/chat_bloc/chat_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/bloc/chat_bloc/chat_states.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';
import 'package:metapp/bloc/view_bloc/view_events.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/views/chat_views/chat_view.dart';
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
    final authBloc = context.read<AuthBloc>();
    final viewBloc = context.read<ViewBloc>();
    final chatBloc = context.read<ChatBloc>();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatStateViewingUsersPage) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat'),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  viewBloc.add(const ViewEventGoToHomePage());
                },
                icon: const Icon(
                  Icons.home,
                ),
              ),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: MenuAction.logout,
                        child: Text('Log out'),
                      )
                    ];
                  },
                  onSelected: (value) async {
                    switch (value) {
                      case MenuAction.logout:
                        final shouldLogOut = await showLogOutDialog(context);
                        if (shouldLogOut) {
                          chatBloc.add(
                            const ChatEventWantToViewUsersPage(),
                          );
                          viewBloc.add(
                            const ViewEventGoToHomePage(),
                          );
                          authBloc.add(
                            const AuthEventLogOut(),
                          );
                        }
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ],
            ),
            body: Container(
              decoration: backgroundDecoration,
              child: StreamBuilder<Iterable<ChatUser>>(
                stream: cloudStorage.allUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (!snapshot.hasData) {
                        return Scaffold(
                          body: Container(
                            decoration: backgroundDecoration,
                            child: const Center(
                              child: Text(
                                'No users yet',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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
          );
        } else {
          return Scaffold(
            body: Text(state.toString()),
          );
        }
      },
    );
  }
}
