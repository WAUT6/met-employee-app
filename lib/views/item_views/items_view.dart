import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/routes.dart';

import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';

import 'package:metapp/views/item_views/items_grid_view.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewBloc>(
      create: (context) => context.read<ViewBloc>(),
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text('Items'),
        //   leading: IconButton(
        //     onPressed: () {
        //       context.read<ViewBloc>().add(const ViewEventGoToHomePage());
        //     },
        //     icon: const Icon(Icons.home),
        //   ),
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         Navigator.pushNamed(
        //           context,
        //           createOrUpdateItemRoute,
        //         );
        //       },
        //       icon: const Icon(Icons.add),
        //     ),
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
        //               viewBloc.add(
        //                 const ViewEventGoToHomePage(),
        //               );
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
        body: StreamBuilder(
          stream: _cloudStorage.allItems(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allItems = snapshot.data as Iterable<CloudItem>;
                  return ItemsGridView(
                    items: allItems,
                    onTap: (item) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateItemRoute,
                        arguments: item,
                      );
                    },
                  );
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
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
    );
  }
}
