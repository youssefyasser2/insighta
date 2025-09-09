import 'package:test_app/features/therapy/domain/entities/therapist.dart';
import 'package:test_app/features/therapy/domain/repositories/therapy_repository.dart';

/// Implementation of the TherapyRepository interface.
/// Provides methods to fetch therapist data with simulated network delay and enhanced error handling.
class TherapyRepositoryImpl implements TherapyRepository {
  /// Mock data simulating a database or API response
  final List<Therapist> _mockTherapists = const [
    Therapist(
      id: '1',
      name: 'Dr. Mohammad Breasat',
      specialization: 'Anxiety Disorders, Panic Attacks',
      rating: 2,
      reviewCount: 124,
      imageUrl: 'assets/images/doc.png',
      tags: ['Anxiety', 'Panic Attacks', 'Mindfulness'],
      address: '123 Wellness St, Therapy City',
      isAvailable: true,
      availableDays: ['Mon', 'Wed', 'Fri'],
      yearsOfExperience: 12,
      bio:
          'Dr. Mohammad Breasat specializes in helping patients manage anxiety through mindfulness techniques.',
    ),
    Therapist(
      id: '2',
      name: 'Dr. Ahmed Omar',
      specialization: 'Depression, Cognitive Behavioral Therapy',
      rating: 4.9,
      reviewCount: 89,
      imageUrl: 'assets/images/doc2.png',
      tags: ['Depression', 'CBT', 'Mood Disorders'],
      address: '456 Harmony Rd, Counseling Town',
      isAvailable: true,
      availableDays: ['Tue', 'Thu', 'Sat'],
      yearsOfExperience: 15,
      bio:
          'Dr. Ahmed Omar is an expert in cognitive behavioral therapy for depression and mood disorders.',
    ),
    Therapist(
      id: '3',
      name: 'Dr. Sarah Johnson',
      specialization: 'Relationship Counseling, Family Therapy',
      rating: 4.7,
      reviewCount: 156,
      imageUrl: 'assets/images/doc2.png',
      tags: ['Relationships', 'Couples', 'Family'],
      address: '789 Love Lane, Family Village',
      isAvailable: false,
      availableDays: ['Mon', 'Wed'],
      yearsOfExperience: 8,
      bio:
          'Dr. Sarah Johnson provides compassionate relationship and family therapy services.',
    ),
    Therapist(
      id: '4',
      name: 'Dr. Michael Chen',
      specialization: 'ADHD, Child Psychology',
      rating: 4.6,
      reviewCount: 78,
      imageUrl: 'assets/images/doc.png',
      tags: ['ADHD', 'Children', 'Behavioral Therapy'],
      address: '101 Child St, Pediatric Zone',
      isAvailable: true,
      availableDays: ['Tue', 'Fri'],
      yearsOfExperience: 7,
      bio:
          'Dr. Michael Chen focuses on ADHD and child psychology with a behavioral approach.',
    ),
    Therapist(
      id: '5',
      name: 'Dr. Emily Rodriguez',
      specialization: 'Trauma, PTSD',
      rating: 4.85,
      reviewCount: 95,
      imageUrl: 'assets/images/doc.png',
      tags: ['Trauma', 'PTSD', 'EMDR'],
      address: '202 Healing Ave, Trauma Center',
      isAvailable: false,
      availableDays: ['Wed', 'Sat'],
      yearsOfExperience: 10,
      bio:
          'Dr. Emily Rodriguez specializes in trauma and PTSD treatment using EMDR techniques.',
    ),
    Therapist(
      id: '6',
      name: 'Dr. James Patel',
      specialization: 'Stress Management, Mindfulness',
      rating: 4.65,
      reviewCount: 112,
      imageUrl: 'assets/images/doc.png',
      tags: ['Stress', 'Mindfulness', 'Meditation'],
      address: '303 Peace Rd, Calm City',
      isAvailable: true,
      availableDays: ['Mon', 'Thu'],
      yearsOfExperience: 9,
      bio:
          'Dr. James Patel offers stress management through mindfulness and meditation.',
    ),
    Therapist(
      id: '7',
      name: 'Dr. Lisa Wong',
      specialization: 'Eating Disorders, Body Image',
      rating: 4.75,
      reviewCount: 67,
      imageUrl: 'assets/images/doc2.png',
      tags: ['Eating Disorders', 'Body Image', 'Self-esteem'],
      address: '404 Balance St, Wellness District',
      isAvailable: true,
      availableDays: ['Tue', 'Fri'],
      yearsOfExperience: 6,
      bio:
          'Dr. Lisa Wong helps patients with eating disorders and body image issues.',
    ),
    Therapist(
      id: '8',
      name: 'Dr. Robert Klein',
      specialization: 'Addiction Recovery, Substance Abuse',
      rating: 4.7,
      reviewCount: 134,
      imageUrl: 'assets/images/doc.png',
      tags: ['Addiction', 'Substance Abuse', 'Recovery'],
      address: '505 Recovery Ln, Sobriety Town',
      isAvailable: false,
      availableDays: ['Wed', 'Sat'],
      yearsOfExperience: 13,
      bio:
          'Dr. Robert Klein specializes in addiction recovery and substance abuse treatment.',
    ),
    Therapist(
      id: '9',
      name: 'Dr. Nora Abdullah',
      specialization: 'Women\'s Mental Health, Emotional Balance',
      rating: 4.9,
      reviewCount: 102,
      imageUrl: 'assets/images/doc2.png',
      tags: ['Women\'s Health', 'Emotional Balance', 'Anxiety'],
      address: '606 Empowerment St, Women\'s Zone',
      isAvailable: true,
      availableDays: ['Mon', 'Fri'],
      yearsOfExperience: 11,
      bio:
          'Dr. Nora Abdullah focuses on women\'s mental health and emotional balance.',
    ),
    Therapist(
      id: '10',
      name: 'Dr. Yusuf Khalil',
      specialization: 'Psychodynamic Therapy, Depression',
      rating: 4.55,
      reviewCount: 88,
      imageUrl: 'assets/images/doc.png',
      tags: ['Psychodynamic Therapy', 'Depression', 'Mental Health'],
      address: '707 Insight Rd, Therapy Hub',
      isAvailable: false,
      availableDays: ['Tue', 'Thu'],
      yearsOfExperience: 5,
      bio:
          'Dr. Yusuf Khalil offers psychodynamic therapy for depression and mental health.',
    ),
  ];

  /// Fetches a list of top-rated therapists.
  /// Simulates an API call with a 500ms delay.
  /// Returns a Future containing a list of Therapist entities.
  /// Throws an Exception if the fetch operation fails.
  @override
  Future<List<Therapist>> getBestTherapists() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return List<Therapist>.from(_mockTherapists);
    } catch (e) {
      throw Exception('Failed to fetch therapists: $e');
    }
  }

  /// Fetches a therapist by their unique ID.
  /// Throws an Exception if the therapist ID is empty or not found.
  /// Returns a Future containing a single Therapist entity.
  @override
  Future<Therapist> getTherapistById(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('Therapist ID cannot be empty');
      }

      await Future.delayed(const Duration(milliseconds: 200));
      final therapist = _mockTherapists.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Therapist with ID $id not found'),
      );
      return therapist;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches therapists by availability status.
  /// Returns a Future containing a list of Therapist entities filtered by [isAvailable].
  @override
  Future<List<Therapist>> getTherapistsByAvailability(bool isAvailable) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return List<Therapist>.from(
        _mockTherapists.where((t) => t.isAvailable == isAvailable),
      );
    } catch (e) {
      throw Exception('Failed to fetch therapists by availability: $e');
    }
  }

  /// Fetches therapists by specialization.
  /// Returns a Future containing a list of Therapist entities filtered by [specialization].
  @override
  Future<List<Therapist>> getTherapistsBySpecialization(
    String specialization,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return List<Therapist>.from(
        _mockTherapists.where(
          (t) => t.specialization.toLowerCase().contains(
            specialization.toLowerCase(),
          ),
        ),
      );
    } catch (e) {
      throw Exception('Failed to fetch therapists by specialization: $e');
    }
  }
}
