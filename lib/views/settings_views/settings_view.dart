import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/services/settings/settings_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

//TODO continue implementing settings page
class _SettingsViewState extends State<SettingsView> {
  late final SettingsProvider _settingsProvider;

  @override
  void initState() {
    _settingsProvider = SettingsProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return BlocProvider<ViewBloc>(
      create: (context) => ViewBloc(),
      child: Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () {
        //       context.read<ViewBloc>().add(
        //             const ViewEventGoToHomePage(),
        //           );
        //     },
        //     icon: const Icon(Icons.home),
        //   ),
        //   title: const Text('Settings'),
        //   centerTitle: true,
        //   actions: [
        //     PopupMenuButton(
        //       itemBuilder: (context) {
        //         return const [
        //           PopupMenuItem(
        //             value: MenuAction.logout,
        //             child: Text('Log out'),
        //           )
        //         ];
        //       },
        //       onSelected: (value) async {
        //         switch (value) {
        //           case MenuAction.logout:
        //             final shouldLogOut = await showLogOutDialog(context);
        //             if (shouldLogOut) {
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
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                tileColor: Colors.black,
                title: const Text(
                  'Edit User Nickname',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                tileColor: Colors.black,
                style: ListTileStyle.list,
                title: const Text(
                  'Edit User Profile Picture',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                tileColor: Colors.black,
                style: ListTileStyle.list,
                title: const Text(
                  'Edit User About Me',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                tileColor: Colors.black,
                style: ListTileStyle.list,
                title: const Text(
                  'Log Out',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onTap: () async {
                  final logOut = await showLogOutDialog(context);
                  if (logOut) {
                    authBloc.add(const AuthEventLogOut());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
