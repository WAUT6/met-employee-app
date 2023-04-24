import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_bloc.dart';
import 'package:metapp/services/auth/bloc/auth_events.dart';

class HomeMenuView extends StatefulWidget {
  const HomeMenuView({super.key});

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MET APP'),
        centerTitle: true,
        titleSpacing: 0.5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.purple,
          //   ],
          // ),
          image: DecorationImage(
            image: AssetImage(
              "assets/images/diamond_background.jpeg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(
                      200,
                      50,
                    ),
                  ),
                ),
                child: const Text('Items'),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventGoToItemsList(),
                      );
                },
              ),
              const SizedBox(
                width: 50,
                height: 50,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(
                      200,
                      50,
                    ),
                  ),
                ),
                child: const Text('Orders'),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventGoToOrdersList(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
