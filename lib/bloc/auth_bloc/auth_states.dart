import 'package:equatable/equatable.dart';
import 'package:metapp/services/auth/auth_user.dart';

abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateViewingItems extends AuthState {
  const AuthStateViewingItems({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateViewingOrders extends AuthState {
  const AuthStateViewingOrders({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateViewingHomePage extends AuthState {
  const AuthStateViewingHomePage({required bool isLoading})
      : super(isLoading: isLoading);
}
