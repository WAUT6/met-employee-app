import 'package:flutter/material.dart';
import 'package:metapp/services/cloud/cloud_order_item.dart';

import '../../../widgets/cloud_order_item_checkbox_widget.dart';

typedef OnTapCallBack = void Function(CloudOrderItem);

class OrderItemsGridView extends StatelessWidget {
  final String orderId;
  final Iterable<CloudOrderItem> orderItems;
  final OnTapCallBack onTap;
  const OrderItemsGridView({
    super.key,
    required this.orderItems,
    required this.onTap,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5,),
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final orderItem = orderItems.elementAt(index);
          return Row(
            children: [
              CloudOrderCheckBox(item: orderItem, orderId: orderId,),
              GestureDetector(
                onTap:() => onTap(orderItem),
                child: Container(
                  height: 75,
                  margin: const EdgeInsets.only(bottom: 5),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(orderItem.itemName, textAlign: TextAlign.start,),
                              const SizedBox(height: 5,),
                              Text('Quantity: ${orderItem.quantity}', textAlign: TextAlign.start,),
                            ],
                          ),
                        ),
                        Text(orderItem.packaging),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    // return GridView.builder(
    //   padding: const EdgeInsets.all(10),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 3,
    //     crossAxisSpacing: 5,
    //     mainAxisSpacing: 5,
    //   ),
    //   itemCount: orderItems.length,
    //   itemBuilder: (context, index) {
    //     final orderItem = orderItems.elementAt(index);
    //     return InkWell(
    //       onTap: () => onTap(orderItem),
    //       child: GridTile(
    //         header: Text(
    //           "Quantity: ${orderItem.quantity}",
    //           textAlign: TextAlign.center,
    //         ),
    //         footer: Text(
    //           "Packaging: ${orderItem.packaging}",
    //           textAlign: TextAlign.center,
    //         ),
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Colors.blueGrey,
    //             borderRadius: BorderRadius.circular(30),
    //           ),
    //           padding: const EdgeInsets.all(16),
    //           child: Center(
    //             child: Text(
    //               orderItem.itemName,
    //               style: const TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 15,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
