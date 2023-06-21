import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:metapp/services/auth/auth_service.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final AuthService _authService = AuthService.firebase();
  String? mToken = '';
  @override
  void initState() {
    context.read<NotificationsBloc>().add(NotificationsEventSetUpNotifications(userId: _authService.currentUser!.id));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
