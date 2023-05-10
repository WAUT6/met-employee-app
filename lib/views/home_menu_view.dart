import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/views/chat_views/users_view.dart';
import 'package:metapp/views/item_views/items_view.dart';
import 'package:metapp/views/order_views/orders_view.dart';
import 'package:metapp/views/settings_views/settings_view.dart';

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

  int _index = 2;
  final _views = const [
    ItemsView(),
    OrdersView(),
    UsersView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        backgroundColor: Colors.white,
        activeColor: Colors.black,
        items: const [
          TabItem(
            activeIcon: Icon(
              Icons.list_alt,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.list_alt,
              color: Colors.black,
            ),
          ),
          TabItem(
            activeIcon: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
            ),
          ),
          TabItem(
            activeIcon: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.chat,
              color: Colors.black,
            ),
          ),
          TabItem(
            activeIcon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _views[_index],
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       context.read<ViewBloc>().add(
      //             const ViewEventGoToSettings(),
      //           );
      //     },
      //     icon: const Icon(Icons.settings),
      //   ),
      //   actions: [
      //     PopupMenuButton(
      //       itemBuilder: (context) {
      //         return [
      //           const PopupMenuItem(
      //             value: MenuAction.logout,
      //             child: Text('Log out'),
      //           )
      //         ];
      //       },
      //       onSelected: (value) async {
      //         switch (value) {
      //           case MenuAction.logout:
      //             final shouldLogout = await showLogOutDialog(context);
      //             if (shouldLogout) {
      //               authBloc.add(
      //                 const AuthEventLogOut(),
      //               );
      //             }
      //             break;
      //           default:
      //             break;
      //         }
      //       },
      //     ),
      //   ],
      // ),
      // body: BlocProvider(
      //   create: (context) => ChatBloc(ChatProvider()),
      //   child: BlocBuilder<ViewBloc, ViewState>(
      //     builder: (context, state) {
      //       if (state is ViewStateViewingHomePage) {
      //         final viewBloc = context.read<ViewBloc>();
      //         final chatBloc = context.read<ChatBloc>();

      //         // bottomNavigationBar: BottomNavigationBar(items: items),
      //         return Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               genericNiceButton(
      //                 context: context,
      //                 text: 'Items',
      //                 funtion: (finish) {
      //                   viewBloc.add(
      //                     const ViewEventGoToItems(),
      //                   );
      //                 },
      //               ),
      //               const SizedBox(
      //                 width: 50,
      //                 height: 50,
      //               ),
      //               genericNiceButton(
      //                 context: context,
      //                 text: 'Orders',
      //                 funtion: (finish) {
      //                   viewBloc.add(
      //                     const ViewEventGoToOrders(),
      //                   );
      //                 },
      //               ),
      //               const SizedBox(
      //                 width: 50,
      //                 height: 50,
      //               ),
      //               genericNiceButton(
      //                 context: context,
      //                 text: 'Chat',
      //                 funtion: (finish) {
      //                   viewBloc.add(const ViewEventGoToChats());
      //                   chatBloc.add(const ChatEventWantToViewUsersPage());
      //                 },
      //               )
      //             ],
      //           ),
      //         );
      //       } else if (state is ViewStateViewingItems) {
      //         return const ItemsView();
      //       } else if (state is ViewStateViewingOrders) {
      //         return const OrdersView();
      //       } else if (state is ViewStateViewingChats) {
      //         return const UsersView();
      //       } else if (state is ViewStateViewingSettings) {
      //         return const SettingsView();
      //       } else {
      //         return Scaffold(
      //           body: Text(state.toString()),
      //         );
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
