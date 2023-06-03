import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/widgets/heart_widget.dart';

typedef UserTapCallBack = void Function(ChatUser user);

class UsersListView extends StatelessWidget {
  final Iterable<ChatUser> users;
  final UserTapCallBack onTapTile;
  final String currentUserId;

  const UsersListView({
    super.key,
    required this.users,
    required this.onTapTile,
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
          return GestureDetector(
            onTap: () {
              return onTapTile(user);
            },
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: HeartWidget(
                        currentUserId: currentUserId, favoriteUser: user),
                  ),
                  Row(
                    children: [
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
                          foregroundImage: user.profileImageUrl.isNotEmpty
                              ? NetworkImage(user.profileImageUrl)
                              : const NetworkImage(fallBackImage),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.nickname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  const Icon(
                    color: Colors.white,
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
