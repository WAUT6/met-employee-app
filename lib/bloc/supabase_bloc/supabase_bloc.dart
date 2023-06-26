
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:metapp/services/cloud/supabase/supabase_provider.dart';

part 'supabase_event.dart';
part 'supabase_state.dart';

class SupabaseBloc extends Bloc<SupabaseEvent, SupabaseState> {
  SupabaseBloc(SupabaseProvider provider) : super(const SupabaseStateUninitialized()) {
    on<SupabaseEventInitialize>((event, emit) async {
      try {
        await provider.initialize();
        emit(const SupabaseStateInitialized());
      } catch(e) {
        Fluttertoast.showToast(msg: 'Could Not Initialize Supabase');
      }
    });
  }
}
