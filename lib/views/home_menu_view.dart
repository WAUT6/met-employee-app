import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';
import 'package:metapp/bloc/view_bloc/view_events.dart';
import 'package:metapp/bloc/view_bloc/view_states.dart';
import 'package:metapp/views/chat_views/users_view.dart';
import 'package:metapp/views/item_views/items_view.dart';
import 'package:metapp/views/order_views/orders_view.dart';

class HomeMenuView extends StatefulWidget {
  const HomeMenuView({super.key});

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView> {
  late final FirebaseCloudStorage _cloudStorage;
  late final AuthService _authService;

  @override
  void initState() {
    _authService = AuthService.firebase();
    _cloudStorage = FirebaseCloudStorage();
    _cloudStorage.addCurrentAuthUserToChatUsers(
        userId: _authService.currentUser!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final viewBloc = context.read<ViewBloc>();
    final chatBloc = context.read<ChatBloc>();
    return BlocBuilder<ViewBloc, ViewState>(
      builder: (context, state) {
        if (state is ViewStateViewingHomePage) {
          return Scaffold(
            bottomNavigationBar: ConvexAppBar(
              items: const [
                TabItem(
                  icon: Icons.book,
                  title: 'Items',
                ),
                TabItem(
                  icon: Icons.shopping_cart,
                  title: 'Orders',
                ),
                TabItem(
                  icon: Icons.message,
                  title: 'Messages',
                ),
                TabItem(
                  icon: Icons.settings,
                  title: 'Settings',
                ),
              ],
              onTap: (index) {},
            ),
            appBar: AppBar(
              title: const Text('MET APP'),
              centerTitle: true,
              titleSpacing: 0.5,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: MenuAction.logout,
                        child: Text('Log out'),
                      )
                    ];
                  },
                  onSelected: (value) async {
                    switch (value) {
                      case MenuAction.logout:
                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    genericNiceButton(
                      context: context,
                      text: 'Items',
                      funtion: (finish) {
                        viewBloc.add(
                          const ViewEventGoToItems(),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                    genericNiceButton(
                      context: context,
                      text: 'Orders',
                      funtion: (finish) {
                        viewBloc.add(
                          const ViewEventGoToOrders(),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                    genericNiceButton(
                      context: context,
                      text: 'Chat',
                      funtion: (finish) {
                        viewBloc.add(const ViewEventGoToChats());
                        chatBloc.add(const ChatEventWantToViewUsersPage());
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (state is ViewStateViewingItems) {
          return const ItemsView();
        } else if (state is ViewStateViewingOrders) {
          return const OrdersView();
        } else if (state is ViewStateViewingChats) {
          return const UsersView();
        } else {
          return Scaffold(
            body: Text(state.toString()),
          );
        }
      },
    );
  }
}
