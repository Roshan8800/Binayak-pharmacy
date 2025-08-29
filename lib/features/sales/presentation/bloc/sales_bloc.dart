import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object> get props => [];
}

class LoadSales extends SalesEvent {}

// States
abstract class SalesState extends Equatable {
  const SalesState();

  @override
  List<Object> get props => [];
}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {}

class SalesError extends SalesState {
  final String message;

  const SalesError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesInitial()) {
    on<LoadSales>(_onLoadSales);
  }

  Future<void> _onLoadSales(LoadSales event, Emitter<SalesState> emit) async {
    emit(SalesLoading());
    try {
      // TODO: Implement sales loading logic
      emit(SalesLoaded());
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }
}