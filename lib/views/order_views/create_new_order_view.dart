import 'package:flutter/material.dart';
import 'package:metapp/constants/themes.dart';
import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';

class CreateNewOrderView extends StatefulWidget {
  const CreateNewOrderView({super.key});

  @override
  State<CreateNewOrderView> createState() => _CreateNewOrderViewState();
}

class _CreateNewOrderViewState extends State<CreateNewOrderView> {
  late final TextEditingController _customerNameController;
  late final TextEditingController _orderIdController;
  late final FirebaseCloudStorage _cloudStorage;
  CloudOrder? _order;

  @override
  void initState() {
    _customerNameController = TextEditingController();
    _orderIdController = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  Future<CloudOrder> createOrder() async {
    final order = await _cloudStorage.createNewOrder();
    _order = order;
    return order;
  }

  void _orderNameControllerListener() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final orderName = _orderIdController.text;
    await _cloudStorage.updateOrderName(
      documentId: order.documentId,
      orderName: orderName,
    );
  }

  void _customerNameControllerListener() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final customerName = _customerNameController.text;
    await _cloudStorage.updateOrderCustomerName(
        documentId: order.documentId, customerName: customerName);
  }

  void setUpControllerListeners() {
    _customerNameController.removeListener(_customerNameControllerListener);
    _customerNameController.addListener(_customerNameControllerListener);
    _orderIdController.removeListener(_orderNameControllerListener);
    _orderIdController.addListener(_orderNameControllerListener);
  }

  void deleteOrderIfTextEmpty() async {
    if (_customerNameController.text.isEmpty ||
        _orderIdController.text.isEmpty) {
      await _cloudStorage.deleteOrder(documentId: _order!.documentId);
    }
  }

  void saveOrderIfTextNotEmpty() async {
    final customerName = _customerNameController.text;
    final orderName = _orderIdController.text;
    if (_customerNameController.text.isNotEmpty &&
        _orderIdController.text.isNotEmpty) {
      await _cloudStorage.updateOrder(
        documentId: _order!.documentId,
        customerName: customerName,
        orderId: orderName,
      );
    }
  }

  @override
  void dispose() {
    deleteOrderIfTextEmpty();
    saveOrderIfTextNotEmpty();
    _customerNameController.dispose();
    _orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        centerTitle: true,
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: FutureBuilder(
            future: createOrder(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  setUpControllerListeners();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _customerNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter customer name',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey,
                          ),
                          enableInteractiveSelection: false,
                          autocorrect: false,
                          enableSuggestions: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _orderIdController,
                          decoration: const InputDecoration(
                            hintText: 'Enter order number',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey,
                          ),
                          enableInteractiveSelection: false,
                          autocorrect: false,
                          enableSuggestions: false,
                        ),
                      ),
                    ],
                  );
                default:
                  return Scaffold(
                    body: Container(
                      decoration: backgroundDecoration,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
