import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/chat/chat_exceptions.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';

class ChatUser {
  final String id;
  final String aboutMe;
  final String profileImageUrl;
  final String nickname;

  const ChatUser({
    required this.id,
    required this.aboutMe,
    required this.profileImageUrl,
    required this.nickname,
  });

  factory ChatUser.fromSnapshot(DocumentSnapshot doc) {
    String aboutMe = '';
    String profileImageUrl = '';
    String nickName = '';

    try {
      aboutMe = doc.get(FirestoreConstants.aboutMe);
      profileImageUrl = doc.get(FirestoreConstants.profileUrl);
      nickName = doc.get(FirestoreConstants.nickname);
    } on StateError catch (_) {
      throw NoUserFoundChatException();
    }
    return ChatUser(
      id: doc.id,
      aboutMe: aboutMe,
      profileImageUrl: profileImageUrl,
      nickname: nickName,
    );
  }
}
