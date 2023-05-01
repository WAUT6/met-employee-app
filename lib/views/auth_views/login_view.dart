import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/auth/auth_exceptions.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/auth_bloc/auth_states.dart';
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
    double h = MediaQuery.of(context).size.height;
    final authBloc = context.read<AuthBloc>();
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
          title: const Text('Log In'),
          centerTitle: true,
        ),
        body: Container(
          decoration: backgroundDecoration,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 0.3,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                                spreadRadius: 1.5,
                                blurRadius: 1.5,
                              ),
                            ],
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.purple,
                              ),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                          height: 35,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 1.5,
                                color: Colors.white,
                                spreadRadius: 1.5,
                              ),
                            ],
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            controller: _password,
                            enableSuggestions: false,
                            obscureText: true,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.purple,
                              ),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          genericNiceButton(
                            context: context,
                            text: 'Login',
                            funtion: (finish) {
                              final String email = _email.text;
                              final String password = _password.text;
                              authBloc.add(
                                AuthEventLogIn(
                                  email: email,
                                  password: password,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 5,
                            height: 15,
                          ),
                          genericNiceButton(
                            context: context,
                            text: 'No account? Register here',
                            funtion: (finish) {
                              authBloc.add(
                                const AuthEventShouldRegister(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
