import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/bloc/share_bloc/share_bloc.dart';
import 'package:metapp/services/chat/chat_user.dart';

class CheckBox extends StatefulWidget {
  final ChatUser user;
  const CheckBox({
    super.key,
    required this.user,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isSelected = false;

  void _handleSelected(BuildContext context) {
    if (_isSelected) {
      context.read<ShareBloc>().add(
            ShareEventRemoveUserFromSelectedUsers(user: widget.user),
          );
      setState(() {
        _isSelected = false;
      });
    } else {
      context.read<ShareBloc>().add(
            ShareEventAddUserToSelectedUsers(user: widget.user),
          );
      setState(() {
        _isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShareBloc(),
      child: IconButton(
        onPressed: () => _handleSelected(context),
        icon: _isSelected
            ? const Image(
                image: AssetImage('assets/images/green-check-box.png'),
              )
            : const Image(
                image: AssetImage('assets/images/check-box.png'),
              ),
      ),
    );
  }
}
