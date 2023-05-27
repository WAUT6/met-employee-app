// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/widgets/checkbox_widget.dart';

typedef UserTapCallBack = void Function(ChatUser user);

class UsersListViewWithCheckBox extends StatefulWidget {
  final Iterable<ChatUser> users;

  final String currentUserId;

  const UsersListViewWithCheckBox({
    super.key,
    required this.users,
    required this.currentUserId,
  });

  @override
  State<UsersListViewWithCheckBox> createState() =>
      _UsersListViewWithCheckBoxState();
}

class _UsersListViewWithCheckBoxState extends State<UsersListViewWithCheckBox> {
  Widget? heart;
  ChatUser? user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        user = widget.users.elementAt(index);
        if (widget.currentUserId == user!.id) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                CheckBox(
                  user: user!,
                ),
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 100,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  foregroundImage:
                                      user!.profileImageUrl.isNotEmpty
                                          ? NetworkImage(user!.profileImageUrl)
                                          : const NetworkImage(fallBackImage),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                user!.nickname,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
