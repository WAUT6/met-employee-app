
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/routes.dart';

import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';

import 'package:metapp/views/item_views/items_grid_view.dart';


class ItemsValueNotifierIterable<CloudItem> extends ValueNotifier<Iterable<CloudItem>> {
  ItemsValueNotifierIterable(Iterable<CloudItem> value) : super(value);

  void add(CloudItem item) {
    value = [...value, item];
  }

  void remove(CloudItem itemToRemove) {
    value = value.where((item) => item != itemToRemove);
  }
}


class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}



class _ItemsViewState extends State<ItemsView> {
  late final TextEditingController _searchController;
  late final FirebaseCloudStorage _cloudStorage;
  Iterable<CloudItem> items = [];


  @override
  void initState() {
    _searchController = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchItems(String query) {
    Iterable<CloudItem> filtered = items
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      items = filtered;
    });
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewBloc>(
      create: (context) => context.read<ViewBloc>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Visibility(
              visible: isVisible,
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
                  decoration: const InputDecoration(
                    hintText: 'Search for item',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  controller: _searchController,
                  autofocus: true,
                  autocorrect: false,
                  onChanged: searchItems,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(onPressed: () {
                  if(isVisible == true) {
                    setState(() {
                      isVisible = false;
                    });
                  } else {
                    setState(() {
                      isVisible = true;
                    });
                  }
              },
                icon: const Icon(Icons.search_outlined), color: Colors.black,),
              IconButton(
                onPressed: () {
                Navigator.pushNamed(context, createOrUpdateItemRoute);
              },
                icon: const Icon(Icons.add_outlined), color: Colors.black,),
            ],
          ),
          body:

          StreamBuilder<Iterable<CloudItem>>(
            stream: _cloudStorage.allItems(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    items = snapshot.data as Iterable<CloudItem>;
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                          ),
                          child: ItemsGridView(
                            items: items,
                            onTap: (item) {
                              Navigator.of(context).pushNamed(
                                createOrUpdateItemRoute,
                                arguments: item,
                              );
                            },
                          ),
                        );
                  } else {
                    return const Scaffold(
                      backgroundColor: Colors.black,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                default:
                  return const Scaffold(
                    backgroundColor: Colors.black,
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
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
