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
import 'package:metapp/utilities/dialogs/logout_dialog.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatStateViewingUsersPage) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat'),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  context.read<ViewBloc>().add(const ViewEventGoToHomePage());
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
                          context.read<ChatBloc>().add(
                                const ChatEventWantToViewUsersPage(),
                              );
                          context.read<ViewBloc>().add(
                                const ViewEventGoToHomePage(),
                              );
                          context.read<AuthBloc>().add(
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
              child: ListView(),
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
