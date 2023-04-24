import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn({
    required this.email,
    required this.password,
  });
}

class AuthEventGoToItemsList extends AuthEvent {
  const AuthEventGoToItemsList();
}

class AuthEventGoToOrdersList extends AuthEvent {
  const AuthEventGoToOrdersList();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventAddOrUpdateItem extends AuthEvent {
  const AuthEventAddOrUpdateItem();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister({
    required this.email,
    required this.password,
  });
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventConfirmNewItem extends AuthEvent {
  final String itemName;
  final double itemPrice;
  const AuthEventConfirmNewItem({
    required this.itemName,
    required this.itemPrice,
  });
}

class AuthEventGoToHomePage extends AuthEvent {
  const AuthEventGoToHomePage();
}
