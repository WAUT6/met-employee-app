import 'package:metapp/services/cloud/supabase/supabase_constants.dart';

class SupabaseCloudOrder {
  final String orderId;
  final String customerName;
  final String employeeName;

  const SupabaseCloudOrder({required this.orderId, required this.customerName, required this.employeeName,});

  SupabaseCloudOrder.fromJSON(Map<String, dynamic> json, this.orderId,) :
      employeeName = json[SupabaseConstants.employeeName] as String,
      customerName = json[SupabaseConstants.customerName] as String;
}