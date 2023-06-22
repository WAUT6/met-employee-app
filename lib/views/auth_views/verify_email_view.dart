import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/auth_bloc/auth_events.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:metapp/constants/themes.dart';
// import 'package:metapp/bloc/auth_bloc/auth_bloc.dart';
// import 'package:metapp/bloc/auth_bloc/auth_events.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    // final authBloc = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Column(
              children: [
                Text(
                  'An email verification has been sent to your email.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "If you haven't received an email please press the button below.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
              width: 15,
            ),
            Column(
              children: [
                ElevatedButton(onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                }, child: const Text('email verified'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
