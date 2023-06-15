import 'package:flutter/material.dart';
import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/utilities/generics/get_arguments.dart';

class CreateOrUpdateItemView extends StatefulWidget {
  const CreateOrUpdateItemView({super.key});

  @override
  State<CreateOrUpdateItemView> createState() => _CreateOrUpdateItemViewState();
}

class _CreateOrUpdateItemViewState extends State<CreateOrUpdateItemView> {
  CloudItem? _item;
  late final TextEditingController _priceController;
  late final TextEditingController _nameController;
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  Future<CloudItem> createOrGetExisitingItem(BuildContext context) async {
    final widgetItem = context.getArgument<CloudItem>();

    if (widgetItem != null) {
      _item = widgetItem;
      _nameController.text = widgetItem.name;
      _priceController.text = widgetItem.price;
      return widgetItem;
    }

    final existingItem = _item;
    if (existingItem != null) {
      return existingItem;
    }

    final newItem = await _cloudStorage.createNewItem();
    _item = newItem;
    return newItem;
  }

  void _nameControllerListener() async {
    final item = _item;
    if (item == null) {
      return;
    }
    final name = _nameController.text;

    await _cloudStorage.updateItemName(
      documentId: item.documentId,
      itemName: name,
    );
  }

  void _priceControllerListener() async {
    final item = _item;
    if (item == null) {
      return;
    }
    final price = _priceController.text;

    await _cloudStorage.updateItemPrice(
      documentId: item.documentId,
      itemPrice: price,
    );
  }

  void _setUpControllerListeners() {
    _nameController.removeListener(_nameControllerListener);
    _nameController.addListener(_nameControllerListener);
    _priceController.removeListener(_priceControllerListener);
    _priceController.addListener(_priceControllerListener);
  }

  void _deleteItemIfBackButtonPressed() async {
    final item = _item;
    if (item != null && _priceController.text.isEmpty ||
        _nameController.text.isEmpty) {
      await _cloudStorage.deleteItem(documentId: item!.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final item = _item;
    final name = _nameController.text;
    final price = _priceController.text;
    if (item != null &&
        _priceController.text.isNotEmpty &&
        _nameController.text.isNotEmpty) {
      await _cloudStorage.updateItem(
        documentId: item.documentId,
        itemName: name,
        itemPrice: price,
      );
    }
  }

  @override
  void dispose() {
    _deleteItemIfBackButtonPressed();
    _saveNoteIfTextIsNotEmpty();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Item'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: createOrGetExisitingItem(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setUpControllerListeners();
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
                            hintText: 'Enter item name',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none

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
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          controller: _priceController,
                          decoration: const InputDecoration(
                            hintText: 'Enter item price',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          enableInteractiveSelection: false,
                          autocorrect: false,
                          enableSuggestions: false,
                        ),
                      ),
                    )
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
