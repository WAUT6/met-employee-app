import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/widgets/heart_widget.dart';

typedef UserTapCallBack = void Function(ChatUser user);

class UsersListView extends StatefulWidget {
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
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  Widget? heart;
  ChatUser? user;

  void setHeart(
    Widget snapHeart,
  ) {
    setState(() {
      heart = snapHeart;
    });
  }

  @override
  void initState() {
    super.initState();
  }

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
            child: GestureDetector(
              onTap: () {
                widget.onTapTile(user!);
              },
              child: Container(
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: HeartWidget(
                            currentUserId: widget.currentUserId,
                            favoriteUser: user!),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              foregroundImage: user!.profileImageUrl.isNotEmpty
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
                      Container(
                        margin: const EdgeInsets.only(
                          left: 195,
                        ),
                        child: const Icon(
                          color: Colors.white,
                          Icons.arrow_forward_ios,
                          size: 25,
                        ),
                      ),
                    ],
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
