import 'package:metapp/services/chat/chat_user.dart';

abstract class ChatState {
  const ChatState();
}

class ChatStateViewingUsersPage extends ChatState {
  const ChatStateViewingUsersPage();
}

class ChatStateMessagingUser extends ChatState {
  final ChatUser receivingUser;
  final String userId;
  const ChatStateMessagingUser({
    required this.receivingUser,
    required this.userId,
  });
}

class ChatStateCheckingUser extends ChatState {
  const ChatStateCheckingUser();
}

class ChatStateUnitialized extends ChatState {
  const ChatStateUnitialized();
}

class ChatStateAddingUserToFavorites extends ChatState {
  const ChatStateAddingUserToFavorites();
}

class ChatStateRemovingUserFromFavorites extends ChatState {
  const ChatStateRemovingUserFromFavorites();
}
