import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/therapy/domain/entities/therapist.dart';
import 'package:test_app/features/therapy/presentation/widgets/therapist_card.dart';

class TherapistGrid extends StatelessWidget {
  final List<Therapist> therapists;

  const TherapistGrid({super.key, required this.therapists});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxCardWidth = 400;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCardWidth,
              mainAxisExtent: 350,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: therapists.length,
            itemBuilder: (context, index) {
              return TherapistCard(
                therapist: therapists[index],
                onTap:
                    () =>
                        _navigateToTherapistDetail(context, therapists[index]),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToTherapistDetail(BuildContext context, Therapist therapist) {
    context.pushNamed('timesheet', extra: therapist);
  }
}
