import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<LoadDetailEvent>(_onLoadDetail);
  }

  void _onLoadDetail(LoadDetailEvent event, Emitter<DetailState> emit) {
    emit(DetailLoaded(event.screenshot));
  }
}
