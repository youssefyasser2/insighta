// timesheet_confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/navigation/routes.dart'; // للتنقل

class TimesheetConfirmationDialog extends StatelessWidget {
  final TimesheetCubit cubit;
  final String? selectedSlot;
  final String? therapistId;
  final DateTime? selectedDate;

  const TimesheetConfirmationDialog({
    super.key,
    required this.cubit,
    this.selectedSlot,
    this.therapistId,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Booking'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (therapistId != null) Text('Therapist ID: $therapistId'),
          if (selectedDate != null)
            Text(
              'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            ),
          const SizedBox(height: 8),
          if (selectedSlot != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('- $selectedSlot'),
              ],
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (selectedDate == null || selectedSlot == null) {
              Navigator.of(context).pop(false); // ❌ فشل
              return;
            }

            await cubit.confirmTimesheet(
              date: selectedDate!,
              timeSlot: selectedSlot!,
            );

            // send result
            if (cubit.state.errorMessage == null) {
              Navigator.of(context).pop(true); // ✅ نجح
            } else {
              Navigator.of(context).pop(false); // ❌ فيه مشكلة
            }
          },
          child: const Text('Confirm Booking'),
        ),
      ],
    );
  }
}
