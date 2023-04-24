import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/routes.dart';
import 'package:metapp/helpers/loading/loading_screen.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/auth/bloc/auth_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';
import 'package:metapp/services/auth/bloc/auth_states.dart';
import 'package:metapp/views/create_update_item_view.dart';
import 'package:metapp/views/home_menu_view.dart';
import 'package:metapp/views/login_view.dart';
import 'package:metapp/views/items_view.dart';
import 'package:metapp/views/register_view.dart';
import 'package:metapp/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        AuthService.firebase(),
      ),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateItemRoute: (context) => const CreateOrUpdateItemView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const HomeMenuView();
      } else if (state is AuthStateViewingItemsList) {
        return const ItemsView();
      } else if (state is AuthStateViewingOrdersList) {
        return const ItemsView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else if (state is AuthStateAddingOrUpdatingItem) {
        return const CreateOrUpdateItemView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    }, listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(context: context, text: 'Please wait a moment...');
      } else {
        LoadingScreen().hide();
      }
    });
  }
}
