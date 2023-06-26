import 'package:metapp/services/cloud/supabase/supabase_constants.dart';

class SupabaseCloudCategory {
  final String categoryId;
  final String categoryName;

  const SupabaseCloudCategory({required this.categoryId, required this.categoryName,});

  SupabaseCloudCategory.fromJSON(Map<String, dynamic> json, this.categoryId,) :
      categoryName = json[SupabaseConstants.categoryName] as String;
}