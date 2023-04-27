import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/paths.dart';
import 'package:metapp/constants/routes.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/services/auth/bloc/auth_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';
import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/views/bloc/view_bloc.dart';
import 'package:metapp/views/bloc/view_events.dart';
import 'package:metapp/views/bloc/view_states.dart';
import 'package:metapp/views/home_menu_view.dart';
import 'package:metapp/views/items_grid_view.dart';

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
    return BlocBuilder<ViewBloc, ViewState>(
      builder: (context, state) {
        if (state is ViewStateViewingItems) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    backgroundImagePath,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
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
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/black_background.jpeg'),
                                  fit: BoxFit.cover),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                    default:
                      return Scaffold(
                        body: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/black_background.jpeg'),
                                fit: BoxFit.cover),
                          ),
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
