import 'package:test_app/features/therapy/domain/entities/therapist.dart';

abstract class TherapyState {}

class TherapyInitial extends TherapyState {}
class TherapyLoading extends TherapyState {}
class TherapyLoaded extends TherapyState {
  final List<Therapist> therapists;
  TherapyLoaded(this.therapists);
}
class TherapyError extends TherapyState {
  final String message;
  TherapyError(this.message);
}