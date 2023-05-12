part of 'settings_bloc.dart';

abstract class SettingsState {
  const SettingsState();
}

class SettingsStateInitialized extends SettingsState {
  const SettingsStateInitialized();
}

class SettingsStateUpdatingUserProfile extends SettingsState {
  const SettingsStateUpdatingUserProfile();
}
