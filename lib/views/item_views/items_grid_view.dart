import 'package:flutter/material.dart';
import 'package:metapp/services/cloud/cloud_item.dart';

typedef ItemCallBack = void Function(CloudItem item);

class ItemsGridView extends StatelessWidget {
  final Iterable<CloudItem> items;
  final ItemCallBack onTap;

  const ItemsGridView({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return InkWell(
          onTap: () {
            onTap(item);
          },
          child: GridTile(
            footer: Text(
              'Price: ${item.price}',
              textAlign: TextAlign.center,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(

                  item.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
