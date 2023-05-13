import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/chat/chat_constants.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:intl/intl.dart';

class ChatListView extends StatelessWidget {
  final Iterable<ChatMessage> messageList;
  final String userId;
  final String peerId;
  const ChatListView({
    super.key,
    required this.messageList,
    required this.userId,
    required this.peerId,
  });

  bool buildChatMessageRight({required int index}) {
    if ((index > 0 && messageList.elementAt(index).idFrom == userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool buildChatMessageLeft({required int index}) {
    if ((index > 0 && messageList.elementAt(index).idFrom != userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildItem({required int index, required ChatMessage message}) {
    if (message.idFrom == userId) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          message.contentType == ChatMessageType.text
              ? Container(
                  padding: const EdgeInsets.fromLTRB(
                    15,
                    10,
                    15,
                    10,
                  ),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(
                    bottom: buildChatMessageRight(
                      index: index,
                    )
                        ? 20
                        : 10,
                    right: 10,
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.only(
                    bottom: buildChatMessageRight(
                      index: index,
                    )
                        ? 20
                        : 10,
                    right: 10,
                  ),
                  child: OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0))),
                    onPressed: () {},
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        fit: BoxFit.cover,
                        message.content,
                        loadingBuilder: ((context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 200,
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        }),
                        errorBuilder: ((context, error, stackTrace) {
                          return Material(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              fallBackImage,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
        ],
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                message.contentType == ChatMessageType.text
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(
                          15,
                          10,
                          15,
                          10,
                        ),
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          message.content,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: 200,
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(0),
                            ),
                          ),
                          onPressed: () {},
                          child: Material(
                            child: Image.network(
                              message.content,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  borderRadius: BorderRadius.circular(10),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset(
                                    fallBackImage,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            buildChatMessageLeft(
              index: index,
            )
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 50,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(message.timeStamp),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          final message = messageList.elementAt(index);
          return buildItem(
            index: index,
            message: message,
          );
        },
        reverse: true,
      ),
    );
  }
}
