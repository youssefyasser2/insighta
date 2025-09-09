import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_cubit.dart';
import 'package:test_app/features/timeslot/logic/cubit/timesheet_state.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  List<DateTime> getWeekDates(DateTime currentWeekStart) {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = currentWeekStart.add(Duration(days: i));
      if (!date.isBefore(today)) {
        dates.add(date);
      }
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimesheetCubit, TimesheetState>(
      builder: (context, state) {
        final weekDates = getWeekDates(state.currentWeekStart);
        if (weekDates.isEmpty) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: const Text('No available dates for this week'),
          );
        }

        return Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              DateTime date = weekDates[index];
              bool isSelected =
                  state.selectedDate != null &&
                  state.selectedDate!.day == date.day &&
                  state.selectedDate!.month == date.month;

              return GestureDetector(
                onTap: () => context.read<TimesheetCubit>().selectDate(date),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal[600] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal[200]!, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.teal[600],
                        ),
                      ),
                      Text(
                        [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ][date.weekday - 1],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.teal[400],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
