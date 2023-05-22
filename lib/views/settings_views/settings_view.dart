import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/settings_bloc/bloc/bloc/bloc/settings_bloc.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/utilities/dialogs/logout_dialog.dart';
import 'package:metapp/services/settings/settings_provider.dart';
import 'package:metapp/utilities/dialogs/text_field_dialog.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsProvider _settingsProvider;
  late final AuthService _authService;
  late final TextEditingController _nickNameController;
  late final TextEditingController _aboutMeController;
  File? imageFile;
  @override
  void initState() {
    _authService = AuthService.firebase();
    _settingsProvider = SettingsProvider();
    _nickNameController = TextEditingController();
    _aboutMeController = TextEditingController();
    super.initState();
  }

  Future<void> getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery).catchError(
      (e) {
        Fluttertoast.showToast(msg: 'Invalid image');
        return null;
      },
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        uploadFile();
      }
    }
  }

  Future<void> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    BlocProvider.of<SettingsBloc>(context).add(
        SettingsEventUpdateUserProfilePicture(
            imageFile: imageFile!,
            fileName: fileName,
            userId: _authService.currentUser!.id));
  }

  Future<ChatUser> getCurrentChatUser({
    required String id,
  }) async {
    return await _settingsProvider.currentChatUser(id: id);
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final userId = _authService.currentUser!.id;
    return BlocProvider<SettingsBloc>(
      create: (context) {
        return context.read<SettingsBloc>();
      },
      child: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: FutureBuilder(
                      future: getCurrentChatUser(id: userId),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  snapshot.data?.profileImageUrl == ''
                                      ? fallBackImage
                                      : snapshot.data!.profileImageUrl),
                            );
                          default:
                            return const CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(fallBackImage),
                            );
                        }
                      }),
                ),
                FutureBuilder(
                  future: getCurrentChatUser(id: userId),
                  builder: ((context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 40,
                          ),
                          child: Center(
                            child: Text(
                              (snapshot.data as ChatUser).nickname,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        );
                      default:
                        return const SizedBox(
                          height: 86,
                        );
                    }
                  }),
                ),
              ],
            ),
            Column(
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
                    onTap: () async {
                      final editNickname = await showTextFieldDialog(
                        title: 'Edit Nickname',
                        context: context,
                        optionsBuilder: () => {
                          'Done': true,
                          'Cancel': false,
                        },
                        controller: _nickNameController,
                      ).then((value) => value ?? false);
                      if (editNickname && context.mounted) {
                        BlocProvider.of<SettingsBloc>(context).add(
                          SettingsEventUpdateUserNickName(
                              nickName: _nickNameController.text,
                              userId: userId),
                        );
                      }
                    },
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
                    onTap: () async {
                      await getImage();
                    },
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
                    onTap: () async {
                      final editAboutMe = await showTextFieldDialog<bool>(
                        context: context,
                        title: 'Edit About Me',
                        optionsBuilder: () => {
                          'Done': true,
                          'Cancel': false,
                        },
                        controller: _aboutMeController,
                      ).then((value) => value ?? false);
                      if (editAboutMe && context.mounted) {
                        BlocProvider.of<SettingsBloc>(context).add(
                          SettingsEventUpdateUserAboutMe(
                            aboutMe: _aboutMeController.text,
                            userId: userId,
                          ),
                        );
                      }
                    },
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
          ],
        ),
      ),
    );
  }
}
