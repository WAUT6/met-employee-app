import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metapp/constants/routes.dart';

import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/firebase_cloud_storage.dart';
import 'package:metapp/bloc/view_bloc/view_bloc.dart';

import 'package:metapp/views/item_views/items_grid_view.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewBloc>(
      create: (context) => context.read<ViewBloc>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined), color: Colors.black,),
              IconButton(onPressed: () {
                Navigator.pushNamed(context, createOrUpdateItemRoute);
              }, icon: const Icon(Icons.add_outlined), color: Colors.black,),
            ],
          ),
          body: StreamBuilder(
            stream: _cloudStorage.allItems(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allItems = snapshot.data as Iterable<CloudItem>;
                    return Container(

                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                      ),
                      child: ItemsGridView(
                        items: allItems,
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
