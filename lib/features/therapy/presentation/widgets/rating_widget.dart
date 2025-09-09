import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure rating is within 0-5 range
    final normalizedRating = rating.clamp(0.0, 5.0);
    final starCount = normalizedRating.floor();
    final halfStar = normalizedRating - starCount >= 0.5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dynamic star rating
            Row(
              children: List.generate(5, (index) {
                if (index < starCount) {
                  return const Icon(
                    Icons.star,
                    color: Color(0xFFFFB800),
                    size: 16,
                  );
                } else if (index == starCount && halfStar) {
                  return const Icon(
                    Icons.star_half,
                    color: Color(0xFFFFB800),
                    size: 16,
                  );
                } else {
                  return const Icon(
                    Icons.star_border,
                    color: Color(0xFFFFB800),
                    size: 16,
                  );
                }
              }),
            ),
            const SizedBox(width: 4), // Adjusted spacing
            Text(
              normalizedRating.toStringAsFixed(1), // Show one decimal place
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2), // Reduced spacing
        Text(
          '($reviewCount reviews)',
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
