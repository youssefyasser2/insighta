import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_cubit.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_state.dart';

class WeekNavigator extends StatelessWidget {
  const WeekNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimesheetCubit, TimesheetState>(
      builder: (context, state) {
        final weekEnd = state.currentWeekStart.add(const Duration(days: 6));

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed:
                  () => context.read<TimesheetCubit>().navigateWeek(false),
              icon: Icon(Icons.chevron_left, color: Colors.teal[600]),
            ),
            Text(
              '${state.currentWeekStart.day}/${state.currentWeekStart.month} - ${weekEnd.day}/${weekEnd.month}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            IconButton(
              onPressed:
                  () => context.read<TimesheetCubit>().navigateWeek(true),
              icon: Icon(Icons.chevron_right, color: Colors.teal[600]),
            ),
          ],
        );
      },
    );
  }
}
