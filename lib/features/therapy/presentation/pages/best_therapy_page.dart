import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/therapy/presentation/cubit/therapy_cubit.dart';
import 'package:test_app/features/therapy/presentation/cubit/therapy_state.dart';
import 'package:test_app/features/therapy/presentation/widgets/therapist_grid.dart';

class BestTherapyPage extends StatelessWidget {
  const BestTherapyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Best Therapy',
          style: TextStyle(
            fontSize: screenWidth * 0.05, // Responsive font size
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () {
              // Implement filter functionality later
            },
          ),
        ],
      ),
      body: BlocBuilder<TherapyCubit, TherapyState>(
        builder: (context, state) {
          if (state is TherapyLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 2.0,
              ),
            );
          }

          if (state is TherapyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed:
                        () => context.read<TherapyCubit>().loadBestTherapists(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Implement report issue functionality (e.g., navigate to feedback page)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Issue reported to support'),
                        ),
                      );
                    },
                    child: const Text('Report Issue'),
                  ),
                ],
              ),
            );
          }

          if (state is TherapyLoaded) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: TherapistGrid(
                key: const ValueKey('loaded'),
                therapists: state.therapists,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
