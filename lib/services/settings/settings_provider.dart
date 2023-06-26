import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:metapp/services/chat/chat_user.dart';

import '../cloud/firebase/firebase_cloud_storage.dart';

class SettingsProvider {
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();

  static final SettingsProvider _shared = SettingsProvider._sharedInstance();
  SettingsProvider._sharedInstance();
  factory SettingsProvider() => _shared;

  Future<ChatUser> currentChatUser({
    required String id,
  }) async =>
      await _cloudStorage.getCurrentChatUser(id: id).first;

  UploadTask uploadFile({
    required File image,
    required String fileName,
  }) =>
      _cloudStorage.uploadFile(
        image,
        fileName,
      );

  Future<void> updateChatUserNickName({
    required String id,
    required String nickname,
  }) async {
    await _cloudStorage.updateChatUserName(id: id, nickname: nickname);
  }

  Future<void> updateChatUserAboutMe({
    required String id,
    required String aboutMe,
  }) async {
    await _cloudStorage.updateChatUserAboutMe(
      id: id,
      aboutMe: aboutMe,
    );
  }

  Future<void> updateChatUserProfileUrl({
    required String id,
    required String profileUrl,
  }) async {
    await _cloudStorage.updateChatUserProfileUrl(
      id: id,
      profileUrl: profileUrl,
    );
  }
}
