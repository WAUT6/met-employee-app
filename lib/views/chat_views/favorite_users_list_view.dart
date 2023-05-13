import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/views/chat_views/users_list_view.dart';

class FavoriteUsersListView extends StatelessWidget {
  final UserTapCallBack onTap;
  final Iterable<ChatUser> users;
  final String currentUserId;
  const FavoriteUsersListView({
    super.key,
    required this.onTap,
    required this.currentUserId,
    required this.users,
  });

//TODO add feature add to favourites
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => onTap(user),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      user.profileImageUrl.isEmpty
                          ? fallBackImage
                          : user.profileImageUrl,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                ),
                child: Text(
                  user.nickname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
