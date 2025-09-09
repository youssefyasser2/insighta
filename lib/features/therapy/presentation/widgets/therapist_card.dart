import 'package:flutter/material.dart';
import 'package:test_app/features/therapy/domain/entities/therapist.dart';

class TherapistCard extends StatelessWidget {
  final Therapist therapist;
  final VoidCallback onTap;

  const TherapistCard({
    super.key,
    required this.therapist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with teal background
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      therapist.imageUrl,
                      width: isSmall ? 35 : 40,
                      height: isSmall ? 35 : 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          therapist.name,
                          style: TextStyle(
                            fontSize: isSmall ? 13 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          therapist.specialization,
                          style: TextStyle(
                            fontSize: isSmall ? 11 : 12,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          therapist.address,
                          style: TextStyle(
                            fontSize: isSmall ? 9 : 10,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Convention & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.teal,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Conventionnée secteur 2',
                            style: TextStyle(fontSize: 10, color: Colors.teal),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            double value = therapist.rating - index;
                            return Icon(
                              value >= 1
                                  ? Icons.star
                                  : value >= 0.25 && value <= 0.75
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: isSmall ? 12 : 14,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            '(${therapist.reviewCount})',
                            style: TextStyle(
                              fontSize: isSmall ? 10 : 11,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Divider(color: Colors.grey, thickness: 1, height: 20),
                  const SizedBox(height: 8),

                  const Text(
                    'Prochaines disponibilités',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'March',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        'Today',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(7, (index) {
                      final day = 9 + index;
                      final isSelected = day == 9;
                      return Container(
                        width: screenWidth * 0.09,
                        height: screenWidth * 0.09,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? Colors.teal
                                  : Colors.teal.withOpacity(0.1),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.teal
                                    : Colors.teal.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: isSmall ? 10 : 12,
                              color: isSelected ? Colors.white : Colors.teal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'started by',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        'finish by',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  Slider(
                    value: 0.3,
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.teal,
                    inactiveColor: Colors.grey[300],
                    onChanged: (value) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '3AM',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        '4PM',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
