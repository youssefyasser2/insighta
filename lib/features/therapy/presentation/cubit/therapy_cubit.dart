import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/therapy/domain/repositories/therapy_repository.dart';
import 'package:test_app/features/therapy/presentation/cubit/therapy_state.dart';

class TherapyCubit extends Cubit<TherapyState> {
  final TherapyRepository repository;

  TherapyCubit(this.repository) : super(TherapyInitial());

  Future<void> loadBestTherapists() async {
    emit(TherapyLoading());
    try {
      final therapists = await repository.getBestTherapists();
      emit(TherapyLoaded(therapists));
    } catch (e) {
      emit(TherapyError('Failed to load therapists: ${e.toString()}'));
    }
  }
}