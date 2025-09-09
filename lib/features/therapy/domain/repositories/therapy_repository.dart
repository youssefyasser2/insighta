import 'package:test_app/features/therapy/domain/entities/therapist.dart';

abstract class TherapyRepository {
  Future<List<Therapist>> getBestTherapists();
  Future<Therapist> getTherapistById(String id);
}