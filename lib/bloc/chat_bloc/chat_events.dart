import 'package:metapp/services/chat/chat_user.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatEventWantToViewUsersPage extends ChatEvent {
  const ChatEventWantToViewUsersPage();
}

class ChatEventWantToMessageUser extends ChatEvent {
  final ChatUser receivingUser;

  const ChatEventWantToMessageUser({
    required this.receivingUser,
  });
}

class ChatEventCheckCurrentUserInCollection extends ChatEvent {
  final String userId;
  ChatEventCheckCurrentUserInCollection({
    required this.userId,
  });
}

class ChatEventInitialize extends ChatEvent {
  const ChatEventInitialize();
}
