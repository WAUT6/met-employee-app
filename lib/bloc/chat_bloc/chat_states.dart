import 'package:metapp/services/chat/chat_user.dart';

abstract class ChatState {
  const ChatState();
}

class ChatStateViewingUsersPage extends ChatState {
  const ChatStateViewingUsersPage();
}

class ChatStateMessagingUser extends ChatState {
  final ChatUser receivingUser;
  final ChatUser sendingUser;
  const ChatStateMessagingUser({
    required this.receivingUser,
    required this.sendingUser,
  });
}
