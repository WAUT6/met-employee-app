part of 'settings_bloc.dart';

abstract class SettingsEvent {
  final String userId;
  const SettingsEvent({
    required this.userId,
  });
}

class SettingsEventUpdateUserProfilePicture extends SettingsEvent {
  final File imageFile;
  final String fileName;

  const SettingsEventUpdateUserProfilePicture({
    required this.imageFile,
    required this.fileName,
    required String userId,
  }) : super(userId: userId);
}

class SettingsEventUpdateUserAboutMe extends SettingsEvent {
  final String aboutMe;
  const SettingsEventUpdateUserAboutMe({
    required this.aboutMe,
    required String userId,
  }) : super(userId: userId);
}

class SettingsEventUpdateUserNickName extends SettingsEvent {
  final String nickName;

  const SettingsEventUpdateUserNickName({
    required this.nickName,
    required String userId,
  }) : super(userId: userId);
}
