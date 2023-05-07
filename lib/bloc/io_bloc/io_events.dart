import 'package:metapp/services/cloud/cloud_order_item.dart';

abstract class IoEvent {
  const IoEvent();
}

class IoEventWantsToDownloadOrderAsPdf extends IoEvent {
  final String customerName;
  final Iterable<CloudOrderItem> items;
  const IoEventWantsToDownloadOrderAsPdf({
    required this.customerName,
    required this.items,
  });
}
