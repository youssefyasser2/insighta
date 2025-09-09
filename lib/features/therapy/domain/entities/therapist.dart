class Therapist {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> tags;
  final String address;
  final bool isAvailable;
  final List<String> availableDays;
  final int yearsOfExperience;
  final String bio;

  const Therapist({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.tags,
    required this.address,
    required this.isAvailable,
    required this.availableDays,
    required this.yearsOfExperience,
    required this.bio,
  });
}
