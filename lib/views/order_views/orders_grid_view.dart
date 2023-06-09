import 'package:flutter/material.dart';
import 'package:metapp/utilities/dialogs/deletion_confirmation_dialog.dart';

import '../../services/cloud/firebase/cloud_order.dart';


typedef OnTapCallBack = void Function(CloudOrder);
typedef OnTapHoldCallBack = void Function(CloudOrder);

class OrdersGridView extends StatelessWidget {
  final Iterable<CloudOrder> orders;
  final OnTapHoldCallBack onDelete;
  final OnTapCallBack onTap;
  
  const OrdersGridView({
    super.key,
    required this.onDelete,
    required this.orders,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.3,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders.elementAt(index);
          return GestureDetector(
            onLongPress: () async {
              final response = await showDeletionConfirmationDialog(context);
              if(response) {
                onDelete(order);
              } else {
                return;
              }
            },
            onTap: () => onTap(order),
            child: GridTile(
              header: Text(
                order.date,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              footer: Text(
                order.employeeId,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    order.customerId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
