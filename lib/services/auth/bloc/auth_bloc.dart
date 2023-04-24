import 'package:bloc/bloc.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';
import 'package:metapp/services/auth/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthService service)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await service.sendEmailVerification();
        emit(state);
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await service.createUser(
            email: email,
            password: password,
          );
          await service.sendEmailVerification();
          emit(
            const AuthStateNeedsVerification(isLoading: false),
          );
        } on Exception catch (e) {
          emit(
            AuthStateRegistering(exception: e, isLoading: false),
          );
        }
      },
    );

    on<AuthEventInitialize>(
      (event, emit) async {
        await service.initialize();
        final user = service.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(
            const AuthStateNeedsVerification(isLoading: false),
          );
        } else {
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while I log you in',
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await service.login(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(
              const AuthStateNeedsVerification(
                isLoading: false,
              ),
            );
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              AuthStateLoggedIn(
                user: user,
                isLoading: false,
              ),
            );
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await service.logout();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AuthEventGoToHomePage>(
      (event, emit) {
        final user = service.currentUser;
        emit(AuthStateLoggedIn(user: user!, isLoading: false));
      },
    );

    on<AuthEventAddOrUpdateItem>(
      (event, emit) {
        emit(
          AuthStateAddingOrUpdatingItem(
            isLoading: false,
          ),
        );
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(
          const AuthStateRegistering(
            exception: null,
            isLoading: false,
          ),
        );
      },
    );

    on<AuthEventGoToItemsList>(
      (event, emit) {
        emit(
          const AuthStateViewingItemsList(
            isLoading: false,
          ),
        );
      },
    );

    on<AuthEventGoToOrdersList>(
      (event, emit) {
        emit(
          const AuthStateViewingOrdersList(
            isLoading: false,
          ),
        );
      },
    );
  }
}
