import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:metapp/services/chat/chat_user.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final List<ChatUser> _selectedUsers = [];
  final _selectedUsersController = StreamController<List<ChatUser>>.broadcast();

  List<ChatUser> get selectedUsers => _selectedUsers;

  Stream<List<ChatUser>> get selectedUsersStream =>
      _selectedUsersController.stream;

  void dispose() {
    _selectedUsersController.close();
  }

  ShareBloc() : super(ShareInitial()) {
    on<ShareEventAddUserToSelectedUsers>((event, emit) {
      _selectedUsers.add(event.user);
      _selectedUsersController.sink.add(_selectedUsers);
    });

    on<ShareEventRemoveUserFromSelectedUsers>(
      (event, emit) {
        _selectedUsers.remove(event.user);

        _selectedUsersController.sink.add(_selectedUsers);
      },
    );
  }
}
