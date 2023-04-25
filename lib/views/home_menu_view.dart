import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/services/auth/bloc/auth_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/views/bloc/view_bloc.dart';
import 'package:metapp/views/bloc/view_events.dart';

class HomeMenuView extends StatefulWidget {
  const HomeMenuView({super.key});

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.purple,
          //   ],
          // ),
          image: DecorationImage(
            image: AssetImage(
              "assets/images/black_background.jpeg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(
                      200,
                      50,
                    ),
                  ),
                ),
                child: const Text('Items'),
                onPressed: () {
                  context.read<ViewBloc>().add(
                        const ViewEventGoToItems(),
                      );
                },
              ),
              const SizedBox(
                width: 50,
                height: 50,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(
                      200,
                      50,
                    ),
                  ),
                ),
                child: const Text('Orders'),
                onPressed: () {
                  context.read<ViewBloc>().add(
                        const ViewEventGoToOrders(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
