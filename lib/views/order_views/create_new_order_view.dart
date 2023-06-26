import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/services/auth/auth_service.dart';
import 'package:metapp/services/chat/chat_provider.dart';

import '../../bloc/notifications_bloc/notifications_bloc.dart';
import '../../services/chat/chat_user.dart';
import '../../services/cloud/firebase/cloud_order.dart';
import '../../services/cloud/firebase/firebase_cloud_storage.dart';

class CreateNewOrderView extends StatefulWidget {
  const CreateNewOrderView({super.key});

  @override
  State<CreateNewOrderView> createState() => _CreateNewOrderViewState();
}

class _CreateNewOrderViewState extends State<CreateNewOrderView> {
  late final TextEditingController _customerNameController;
  late final FirebaseCloudStorage _cloudStorage;
  final ChatProvider  _chatProvider = ChatProvider();
  final AuthService _authService = AuthService.firebase();
  CloudOrder? _order;

  @override
  void initState() {
    _customerNameController = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  Future<CloudOrder> createOrder() async {
    final ChatUser user = await _chatProvider.currentChatUser(id: _authService.currentUser!.id);
    final order = await _cloudStorage.createNewOrder(user: user);
    _order = order;
    return order;
  }

  void _customerNameControllerListener() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final customerName = _customerNameController.text;
    await _cloudStorage.updateOrder(
        documentId: order.documentId, customerName: customerName);
  }

  void setUpControllerListeners() {
    _customerNameController.removeListener(_customerNameControllerListener);
    _customerNameController.addListener(_customerNameControllerListener);
  }

  void deleteOrderIfTextEmpty() async {
    if (_customerNameController.text.isEmpty) {
      await _cloudStorage.deleteOrder(documentId: _order!.documentId);
    }
  }

  void saveOrderIfTextNotEmpty() async {
    final customerName = _customerNameController.text;
    if (_customerNameController.text.isNotEmpty) {
      await _cloudStorage.updateOrder(
        documentId: _order!.documentId,
        customerName: customerName,
      );
    }
  }

  @override
  void dispose() {
    deleteOrderIfTextEmpty();
    saveOrderIfTextNotEmpty();
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<NotificationsBloc>().add(const NotificationsEventSendNotifications());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('New Order'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: createOrder(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                setUpControllerListeners();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffF7F7F7),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 1.5,
                          blurRadius: 1.5,
                        ),
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      controller: _customerNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Customer Name',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      enableInteractiveSelection: false,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                  ),
                );
              default:
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
