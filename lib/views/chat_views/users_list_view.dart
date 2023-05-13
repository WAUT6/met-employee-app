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
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              height: 100,
              child: Center(
                child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onTap: () => onTap(user),
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      foregroundImage: user.profileImageUrl.isNotEmpty
                          ? NetworkImage(user.profileImageUrl)
                          : const NetworkImage(fallBackImage),
                    ),
                  ),
                  title: Text(
                    user.nickname,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
