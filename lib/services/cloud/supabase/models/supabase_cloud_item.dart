import 'package:metapp/services/cloud/supabase/supabase_constants.dart';

class SupabaseCloudItem {
  final String itemId;
  final String itemName;
  final String categoryId;

  const SupabaseCloudItem({required this.itemId, required this.itemName, required this.categoryId,});

  SupabaseCloudItem.fromJSON(Map<String, dynamic> json, this.itemId) :
      itemName = json[SupabaseConstants.itemName] as String,
      categoryId = json[SupabaseConstants.categoryId] as String;

}