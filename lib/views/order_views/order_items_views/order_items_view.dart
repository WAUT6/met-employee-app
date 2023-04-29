import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';
import 'package:metapp/bloc/view_bloc/view_events.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';

class OrderItemsView extends StatefulWidget {
  const OrderItemsView({super.key});

  @override
  State<OrderItemsView> createState() => _OrderItemsViewState();
}

class _OrderItemsViewState extends State<OrderItemsView> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<ViewBloc>().add(
                  const ViewEventGoToHomePage(),
                );
          },
          icon: const Icon(
            Icons.home,
          ),
        ),
        title: const Text('Order Items'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
            ),
          ),
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
      body: StreamBuilder(
        stream: _cloudStorage.allItems(),
        builder: (context, snapshot) {},
      ),
    );
  }
}
