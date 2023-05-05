import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/constants/routes.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';
import 'package:metapp/bloc/view_bloc/view_events.dart';
import 'package:metapp/bloc/view_bloc/view_states.dart';
import 'package:metapp/views/home_menu_view.dart';
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
    final authBloc = context.read<AuthBloc>();
    final viewBloc = context.read<ViewBloc>();
    return BlocBuilder<ViewBloc, ViewState>(
      builder: (context, state) {
        if (state is ViewStateViewingItems) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Items'),
              leading: IconButton(
                onPressed: () {
                  context.read<ViewBloc>().add(const ViewEventGoToHomePage());
                },
                icon: const Icon(Icons.home),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      createOrUpdateItemRoute,
                    );
                  },
                  icon: const Icon(Icons.add),
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
              child: StreamBuilder(
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
                        return Scaffold(
                          body: Container(
                            decoration: backgroundDecoration,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
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
          );
        } else if (state is ViewStateViewingHomePage) {
          return const HomeMenuView();
        } else {
          return const HomeMenuView();
        }
      },
    );
  }
}
