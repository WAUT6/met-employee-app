import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:metapp/services/settings/settings_provider.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(SettingsProvider provider)
      : super(const SettingsStateInitialized()) {
    on<SettingsEventUpdateUserProfilePicture>((event, emit) async {
      emit(const SettingsStateUpdatingUserProfile());
      UploadTask uploadTask =
          provider.uploadFile(image: event.imageFile, fileName: event.fileName);
      try {
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        await provider.updateChatUserProfileUrl(
            id: event.userId, profileUrl: imageUrl);
        emit(const SettingsStateInitialized());
      } catch (e) {
        emit(const SettingsStateInitialized());
        Fluttertoast.showToast(msg: 'Could Not Update Profile Picture');
      }
    });

    on<SettingsEventUpdateUserAboutMe>(
      (event, emit) async {
        emit(const SettingsStateUpdatingUserProfile());
        try {
          await provider.updateChatUserAboutMe(
              id: event.userId, aboutMe: event.aboutMe);
          emit(const SettingsStateInitialized());
        } catch (e) {
          emit(const SettingsStateInitialized());
          Fluttertoast.showToast(msg: 'Could Not Update About Me');
        }
      },
    );

    on<SettingsEventUpdateUserNickName>(
      (event, emit) async {
        emit(const SettingsStateUpdatingUserProfile());
        try {
          await provider.updateChatUserNickName(
              id: event.userId, nickname: event.nickName);
          emit(const SettingsStateInitialized());
        } catch (e) {
          emit(const SettingsStateInitialized());
        }
      },
    );
  }
}
