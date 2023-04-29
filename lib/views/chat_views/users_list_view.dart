import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_user.dart';

typedef UserTapCallBack = void Function(ChatUser user);

class UsersListView extends StatelessWidget {
  final Iterable<ChatUser> users;
  final UserTapCallBack onTap;
  final String currentUserId;

  const UsersListView({
    super.key,
    required this.users,
    required this.onTap,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users.elementAt(index);
        if (currentUserId == user.id) {
          return const SizedBox.shrink();
        } else {
          return ListTile(
            onTap: () => onTap(user),
            leading: CircleAvatar(
              radius: 25,
              foregroundImage: user.profileImageUrl.isNotEmpty
                  ? NetworkImage(user.profileImageUrl)
                  : const NetworkImage(fallBackImage),
            ),
            title: Text(
              user.nickname,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
