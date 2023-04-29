import 'package:bloc/bloc.dart';
import 'package:metapp/bloc/chat_bloc/chat_events.dart';
import 'package:metapp/bloc/chat_bloc/chat_states.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatStateViewingUsersPage()) {
    on<ChatEventWantToMessageUser>(
      (event, emit) {
        ChatStateMessagingUser(
          receivingUser: event.receivingUser,
        );
      },
    );

    on<ChatEventWantToViewUsersPage>(
      (event, emit) {
        emit(const ChatStateViewingUsersPage());
      },
    );
  }
}
