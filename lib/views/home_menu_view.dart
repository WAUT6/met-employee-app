import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/views/chat_views/users_view.dart';
import 'package:metapp/views/dashboard_views/dashboard_view.dart';
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
  final List<StatefulWidget> _views = <StatefulWidget>[];

  @override
  void initState() {
    const itemsView = ItemsView();
    final ordersView = OrdersView();
    const usersView = UsersView();
    const settingsView = SettingsView();
    const dashboardView = DashboardView();
    _authService = AuthService.firebase();
    _cloudStorage = FirebaseCloudStorage();
    _cloudStorage.addCurrentAuthUserToChatUsers(
        userId: _authService.currentUser!.id);
    _views.addAll([
      itemsView,
      ordersView,
      dashboardView,
      usersView,
      settingsView,
    ]);
    super.initState();
  }

  int _index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Icons.dashboard,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.dashboard,
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
    );
  }
}
