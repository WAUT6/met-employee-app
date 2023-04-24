import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/services/auth/auth_exceptions.dart';
import 'package:metapp/services/auth/bloc/auth_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';
import 'package:metapp/services/auth/bloc/auth_states.dart';
import 'package:metapp/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/black_background.jpeg'),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                      height: 35,
                    ),
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      controller: _password,
                      enableSuggestions: false,
                      obscureText: true,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final String email = _email.text;
                        final String password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                email: email,
                                password: password,
                              ),
                            );
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                      width: 5,
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventShouldRegister(),
                            );
                      },
                      child: const Text('No account? Register here.'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
