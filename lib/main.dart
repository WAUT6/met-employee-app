import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/io_bloc/io_bloc.dart';
import 'package:metapp/bloc/settings_bloc/bloc/bloc/bloc/settings_bloc.dart';
import 'package:metapp/constants/routes.dart';
import 'package:metapp/helpers/loading/loading_screen.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/auth_bloc/auth_states.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';
import 'package:metapp/services/settings/settings_provider.dart';
import 'package:metapp/views/chat_views/chat_view.dart';
import 'package:metapp/views/item_views/create_update_item_view.dart';
import 'package:metapp/views/home_menu_view.dart';
import 'package:metapp/views/auth_views/login_view.dart';
import 'package:metapp/views/auth_views/register_view.dart';
import 'package:metapp/views/auth_views/verify_email_view.dart';
import 'package:metapp/views/order_views/create_new_order_view.dart';
import 'package:metapp/views/order_views/order_items_views/create_update_order_item_view.dart';
import 'package:metapp/views/order_views/order_items_views/order_items_view.dart';

void main() {
  final ThemeData theme = ThemeData();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            AuthService.firebase(),
          ),
        ),
        BlocProvider(
          create: (context) => ViewBloc(),
        ),
        BlocProvider(
          create: (context) => IoBloc(),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(
            SettingsProvider(),
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme.copyWith(
          primaryColor: const Color.fromRGBO(
            243,
            243,
            243,
            1,
          ),
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.black,
          ),
        ),
        home: const HomePage(),
        routes: {
          createOrUpdateItemRoute: (context) => const CreateOrUpdateItemView(),
          viewOrderItemsRoute: (context) => const OrderItemsView(),
          createOrUpdateOrderItemRoute: (context) =>
              const CreateUpdateOrderItemView(),
          createNewOrderRoute: (context) => const CreateNewOrderView(),
          messageUserRoute: (context) => const ChatView(),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const AuthEventInitialize());
    // final chatBloc = context.read<ChatBloc>();
    // chatBloc.add(const ChatEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          // chatBloc.add(
          //     ChatEventCheckCurrentUserInCollection(userId: state.user.id));
          return const HomeMenuView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/black_background.jpeg'),
                    fit: BoxFit.cover),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen()
              .show(context: context, textToShow: 'Please wait a moment...');
        } else {
          LoadingScreen().hide();
        }
      },
    );
  }
}
