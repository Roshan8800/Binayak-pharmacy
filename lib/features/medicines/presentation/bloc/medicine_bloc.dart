import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/medicine_model.dart';
import '../../data/repositories/medicine_repository.dart';

// Events
abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class LoadMedicines extends MedicineEvent {}

class AddMedicine extends MedicineEvent {
  final Medicine medicine;

  const AddMedicine(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class UpdateMedicine extends MedicineEvent {
  final Medicine medicine;

  const UpdateMedicine(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class DeleteMedicine extends MedicineEvent {
  final int id;

  const DeleteMedicine(this.id);

  @override
  List<Object> get props => [id];
}

class SearchMedicines extends MedicineEvent {
  final String query;

  const SearchMedicines(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object> get props => [];
}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;

  const MedicineLoaded(this.medicines);

  @override
  List<Object> get props => [medicines];
}

class MedicineError extends MedicineState {
  final String message;

  const MedicineError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository _repository = MedicineRepository();

  MedicineBloc() : super(MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<AddMedicine>(_onAddMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
    on<SearchMedicines>(_onSearchMedicines);
  }

  Future<void> _onLoadMedicines(LoadMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    try {
      final medicines = await _repository.getAllMedicines();
      emit(MedicineLoaded(medicines));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onAddMedicine(AddMedicine event, Emitter<MedicineState> emit) async {
    try {
      await _repository.insertMedicine(event.medicine);
      add(LoadMedicines());
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onUpdateMedicine(UpdateMedicine event, Emitter<MedicineState> emit) async {
    try {
      await _repository.updateMedicine(event.medicine);
      add(LoadMedicines());
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onDeleteMedicine(DeleteMedicine event, Emitter<MedicineState> emit) async {
    try {
      await _repository.deleteMedicine(event.id);
      add(LoadMedicines());
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onSearchMedicines(SearchMedicines event, Emitter<MedicineState> emit) async {
    emit(MedicineLoading());
    try {
      final medicines = await _repository.searchMedicines(event.query);
      emit(MedicineLoaded(medicines));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }
}