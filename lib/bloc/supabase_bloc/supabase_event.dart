part of 'supabase_bloc.dart';

@immutable
abstract class SupabaseEvent {
  const SupabaseEvent();
}

class SupabaseEventInitialize extends SupabaseEvent {
  const SupabaseEventInitialize();
}
