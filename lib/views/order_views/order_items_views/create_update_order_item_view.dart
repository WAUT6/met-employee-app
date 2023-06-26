import 'package:flutter/material.dart';
import 'package:metapp/utilities/generics/get_arguments.dart';

import '../../../services/cloud/firebase/cloud_order_item.dart';
import '../../../services/cloud/firebase/firebase_cloud_storage.dart';

class CreateUpdateOrderItemView extends StatefulWidget {
  const CreateUpdateOrderItemView({super.key});

  @override
  State<CreateUpdateOrderItemView> createState() =>
      _CreateUpdateOrderItemViewState();
}

class _CreateUpdateOrderItemViewState extends State<CreateUpdateOrderItemView> {
  late final TextEditingController _quantityController;
  late final TextEditingController _nameController;
  late final TextEditingController _packagingController;
  late final FirebaseCloudStorage _cloudStorage;
  late final String _orderId;
  CloudOrderItem? _orderItem;

  @override
  void initState() {
    _quantityController = TextEditingController();
    _nameController = TextEditingController();
    _packagingController = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  Future<CloudOrderItem> getOrCreateItem(BuildContext context) async {
    final argument = context.getArgument<Map<String, dynamic>>();
    final CloudOrderItem widgetOrderItem;
    _orderId = argument!['orderId'];
    if (argument['cloudOrderItem'] != null) {
      widgetOrderItem = argument['cloudOrderItem'];
      _quantityController.text = widgetOrderItem.quantity;
      _nameController.text = widgetOrderItem.itemName;
      _packagingController.text = widgetOrderItem.packaging;
      _orderItem = widgetOrderItem;
      return widgetOrderItem;
    }

    final newOrderItem =
        await _cloudStorage.createNewOrderItem(orderId: _orderId);
    _orderItem = newOrderItem;
    return newOrderItem;
  }

  void _quantityControllerListener() async {
    final orderItem = _orderItem;
    if (orderItem == null) {
      return;
    }
    final itemQuantity = _quantityController.text;
    await _cloudStorage.updateOrderItemQuantity(
      orderId: _orderId,
      documentId: orderItem.id,
      orderItemQuantity: itemQuantity,
    );
  }

  void _nameControllerListener() async {
    final orderItem = _orderItem;
    if (orderItem == null) {
      return;
    }
    final itemName = _nameController.text;
    await _cloudStorage.updateOrderItemName(
      orderId: _orderId,
      documentId: orderItem.id,
      orderItemName: itemName,
    );
  }

  void _packagingControllerListener() async {
    final orderItem = _orderItem;
    if (orderItem == null) {
      return;
    }
    final itemPackaging = _packagingController.text;
    await _cloudStorage.updateOrderItemPackaging(
      orderId: _orderId,
      documentId: orderItem.id,
      orderItemPackaging: itemPackaging,
    );
  }

  void setUpControllerListeners() {
    _nameController.removeListener(_nameControllerListener);
    _nameController.addListener(_nameControllerListener);
    _packagingController.removeListener(_packagingControllerListener);
    _packagingController.addListener(_packagingControllerListener);
    _quantityController.removeListener(_quantityControllerListener);
    _quantityController.addListener(_quantityControllerListener);
  }

  void deleteOrderItemIfBackButtonPressed() async {
    if (_orderItem != null && _quantityController.text.isEmpty ||
        _packagingController.text.isEmpty ||
        _nameController.text.isEmpty) {
      await _cloudStorage.deleteOrderItem(
        orderId: _orderId,
        documentId: _orderItem!.id,
      );
    }
  }

  void saveOrderItemIfTextNotEmpty() async {
    final orderItem = _orderItem;
    final packaging = _packagingController.text;
    final quantity = _quantityController.text;
    final name = _nameController.text;

    if (orderItem != null &&
        _packagingController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _nameController.text.isNotEmpty) {
      await _cloudStorage.updateOrderItem(
        orderId: _orderId,
        documentId: orderItem.id,
        orderItemName: name,
        orderItemQuantity: quantity,
        orderItemPackaging: packaging,
      );
    }
  }

  @override
  void dispose() {
    deleteOrderItemIfBackButtonPressed();
    saveOrderItemIfTextNotEmpty();
    _packagingController.dispose();
    _quantityController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Item'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: getOrCreateItem(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                setUpControllerListeners();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
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

                          controller: _nameController,
                          decoration: const InputDecoration(

                            hintText: 'Enter Item Name',
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
                    ),
                    Padding(
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
                          style: const TextStyle(color: Colors.grey),
                          controller: _quantityController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            hintText: 'Enter Quantity',
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
                    ),
                    Padding(
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
                          style: const TextStyle(color: Colors.grey),
                          controller: _packagingController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            hintText: 'Enter Packaging',
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
                    ),
                  ],
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
