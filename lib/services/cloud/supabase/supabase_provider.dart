import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:metapp/services/cloud/supabase/supabase_cloud_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  static final SupabaseProvider _shared = SupabaseProvider._sharedInstance();
  SupabaseProvider._sharedInstance();
  factory SupabaseProvider() => _shared;

  final url = dotenv.get('SUPABASE_URL', fallback: '');
  final anonKey = dotenv.get('SUPABASE_API_KEY', fallback: '');

  Future<void> initialize() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}