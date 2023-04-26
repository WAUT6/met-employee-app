import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/paths.dart';
import 'package:metapp/enums/menu_action.dart';
import 'package:metapp/services/auth/bloc/auth_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:nice_buttons/nice_buttons.dart';

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
              backgroundImagePath,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NiceButtons(
                startColor: Colors.purple,
                endColor: Colors.purple.shade800,
                borderColor: Colors.purple.shade900,
                stretch: false,
                progress: true,
                child: const Text(
                  'Items',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: (finish) {
                  context.read<AuthBloc>().add(
                        const AuthEventGoToItems(),
                      );
                  Timer(
                    const Duration(seconds: 5),
                    () {
                      finish();
                    },
                  );
                },
              ),
              const SizedBox(
                width: 50,
                height: 50,
              ),
              NiceButtons(
                startColor: Colors.purple,
                endColor: Colors.purple.shade800,
                borderColor: Colors.purple.shade900,
                stretch: false,
                progress: true,
                // style: const ButtonStyle(
                //   minimumSize: MaterialStatePropertyAll(
                //     Size(
                //       200,
                //       50,
                //     ),
                //   ),
                // ),
                child: const Text(
                  'Orders',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: (finish) {
                  context.read<AuthBloc>().add(
                        const AuthEventGoToOrders(),
                      );
                  Timer(
                    const Duration(seconds: 5),
                    () {
                      finish();
                    },
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
