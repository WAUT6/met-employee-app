import 'package:metapp/services/cloud/supabase/supabase_constants.dart';

class SupabaseCloudOrderItem {
  final String itemId;
  final String orderId;
  final String packaging;
  final int quantity;

  const SupabaseCloudOrderItem({required this.itemId, required this.orderId, required this.packaging, required this.quantity,});

  SupabaseCloudOrderItem.fromJSON(Map<String, dynamic> json) :
      itemId = json[SupabaseConstants.itemId] as String,
      orderId = json[SupabaseConstants.orderId] as String,
      packaging = json[SupabaseConstants.packaging] as String,
      quantity = json[SupabaseConstants.quantity] as int;
}