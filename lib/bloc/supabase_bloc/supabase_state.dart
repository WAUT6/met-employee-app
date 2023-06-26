part of 'supabase_bloc.dart';

@immutable
abstract class SupabaseState {
  const SupabaseState();
}

class SupabaseStateUninitialized extends SupabaseState {
  const SupabaseStateUninitialized();
}

class SupabaseStateInitialized extends SupabaseState {
  const SupabaseStateInitialized();
}
