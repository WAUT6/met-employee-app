import 'package:flutter/material.dart';
import 'package:metapp/constants/paths.dart';
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

  void _deleteItemIfBackButtonPressed() {
    final item = _item;
    if (item != null && _priceController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _cloudStorage.deleteItem(documentId: item!.documentId);
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
        title: const Text('Note'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter item name',
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
                          controller: _priceController,
                          decoration: const InputDecoration(
                            hintText: 'Enter item price',
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey,
                          ),
                          keyboardType: TextInputType.number,
                          enableInteractiveSelection: false,
                          autocorrect: false,
                          enableSuggestions: false,
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
      ),
    );
  }
}
