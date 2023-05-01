import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/auth/auth_exceptions.dart';
import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';
import 'package:metapp/bloc/auth_bloc/auth_states.dart';
import 'package:metapp/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak passowrd');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Could not register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Register'),
        ),
        body: Container(
          decoration: backgroundDecoration,
          child: ListView(
            children: [
              SizedBox(
                height: h * 0.3,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
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
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        genericNiceButton(
                          context: context,
                          text: 'Register',
                          funtion: (finish) {
                            final String email = _email.text;
                            final String password = _password.text;
                            authBloc.add(
                              AuthEventRegister(
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
                          text: 'Login here',
                          funtion: (finish) {
                            authBloc.add(
                              const AuthEventLogOut(),
                            );
                          },
                        ),
                      ],
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
