import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/therapy/domain/entities/therapist.dart';
import 'package:test_app/features/timeslot/data/repositories/timesheet_repository.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_cubit.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_state.dart';
import 'package:test_app/features/timeslot/presentation/widgets/date_selector.dart';
import 'package:test_app/features/timeslot/presentation/widgets/time_slot_section.dart';
import 'package:test_app/features/timeslot/presentation/widgets/week_navigator.dart';
import 'package:test_app/features/timeslot/presentation/widgets/timesheet_confirmation_dialog.dart';

class TimesheetPage extends StatelessWidget {
  final Therapist therapist;

  static const List<String> morningSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];
  static const List<String> noonSlots = [
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
  ];
  static const List<String> nightSlots = [
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
  ];

  const TimesheetPage({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    if (therapist.id.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Invalid therapist data',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => TimesheetCubit(therapist, TimesheetRepository()),
      child: BlocListener<TimesheetCubit, TimesheetState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
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
            title: const Text(
              'Select Time Slots',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<TimesheetCubit, TimesheetState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WeekNavigator(),
                    const SizedBox(height: 16),
                    const DateSelector(),
                    const SizedBox(height: 32),
                    if (state.selectedDate != null) ...[
                      TimeSlotSection(
                        title: 'Morning',
                        timeSlots: morningSlots,
                        onTimeSelected:
                            (slot) => _showConfirmationDialog(context, slot),
                      ),
                      const SizedBox(height: 24),
                      TimeSlotSection(
                        title: 'Noon',
                        timeSlots: noonSlots,
                        onTimeSelected:
                            (slot) => _showConfirmationDialog(context, slot),
                      ),
                      const SizedBox(height: 24),
                      TimeSlotSection(
                        title: 'Night',
                        timeSlots: nightSlots,
                        onTimeSelected:
                            (slot) => _showConfirmationDialog(context, slot),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Please select a date to view available time slots',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String selectedSlot) {
    final cubit = BlocProvider.of<TimesheetCubit>(context);

    showDialog(
      context: context,
      builder:
          (context) => TimesheetConfirmationDialog(
            cubit: cubit,
            selectedSlot: selectedSlot,
            therapistId: therapist.id,
            selectedDate: cubit.state.selectedDate,
          ),
    ).then((confirmed) {
      final selectedDate = cubit.state.selectedDate;

      if (confirmed == true && selectedDate != null) {
        context.pushNamed(
          'bookingSuccess',
          extra: {'date': selectedDate, 'time': selectedSlot},
        );
      }
    });
  }
}
