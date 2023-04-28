import 'package:metapp/services/chat/chat_user.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatEventWantToViewUsersPage extends ChatEvent {
  const ChatEventWantToViewUsersPage();
}

class ChatEventWantToMessageUser extends ChatEvent {
  final ChatUser sendingUser;
  final ChatUser receivingUser;

  const ChatEventWantToMessageUser({
    required this.sendingUser,
    required this.receivingUser,
  });
}