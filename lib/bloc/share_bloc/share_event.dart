part of 'share_bloc.dart';

abstract class ShareEvent {
  const ShareEvent();
}

class ShareEventAddUserToSelectedUsers extends ShareEvent {
  final ChatUser user;
  const ShareEventAddUserToSelectedUsers({
    required this.user,
  });
}

class ShareEventRemoveUserFromSelectedUsers extends ShareEvent {
  final ChatUser user;
  const ShareEventRemoveUserFromSelectedUsers({
    required this.user,
  });
}
