import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/therapy/domain/entities/therapist.dart';
import 'package:test_app/features/timeslot/data/repositories/timesheet_repository.dart';
import 'timesheet_state.dart';

class TimesheetCubit extends Cubit<TimesheetState> {
  final TimesheetRepository repository;

  TimesheetCubit(Therapist therapist, this.repository)
    : super(
        TimesheetState(
          selectedTimeSlots: [],
          currentWeekStart: DateTime.now().subtract(
            Duration(days: DateTime.now().weekday % 7),
          ),
          therapist: therapist,
        ),
      );

  // ✅ 1. تحديد التاريخ
  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedTimeSlots: [], // Clear time slots when date changes
        errorMessage: null,
      ),
    );
  }

  // ✅ 2. تبديل وقت زمني (مع تأكيد)
  Function(String) selectTimeSlotWithConfirmation(BuildContext context) {
    return (String timeSlot) {
      if (state.selectedDate == null) {
        // Return a no-op function if date is not selected
        return;
      }

      showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Confirm Booking"),
              content: Text("Are you sure you want to book $timeSlot?"),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    _bookSingleTimeSlot(timeSlot);

                    // ✅ استخدم المتغيرات من الـ state أو مررها مباشرة
                    confirmTimesheet(
                      date: state.selectedDate, // التاريخ المحدد في الـ state
                      timeSlot: timeSlot, // الوقت المؤكد
                    );
                  },
                  child: const Text("Confirm"),
                ),
              ],
            ),
      );
    };
  }

  // ✅ 3. إضافة وقت زمني إلى القائمة
  void _bookSingleTimeSlot(String timeSlot) {
    final newTimeSlots = List<String>.from(state.selectedTimeSlots);

    if (!newTimeSlots.contains(timeSlot)) {
      newTimeSlots.add(timeSlot);
    }

    emit(state.copyWith(selectedTimeSlots: newTimeSlots));
  }

  // ✅ 4. نقل الأسبوع للأمام أو للخلف
  void navigateWeek(bool isNext) {
    final today = DateTime.now();
    final newWeekStart =
        isNext
            ? state.currentWeekStart.add(Duration(days: 7))
            : state.currentWeekStart.subtract(Duration(days: 7));

    if (newWeekStart.isBefore(
      today.subtract(Duration(days: today.weekday % 7)),
    )) {
      return;
    }

    emit(
      state.copyWith(
        currentWeekStart: newWeekStart,
        selectedDate: null,
        selectedTimeSlots: [],
        errorMessage: null,
      ),
    );
  }

  Future<void> confirmTimesheet({
    DateTime? date,
    String? timeSlot,
    List<String>? multipleSlots,
  }) async {
    final therapistId = state.therapist.id;
    final selectedDate = date ?? state.selectedDate;

    if (therapistId.isEmpty) {
      emit(state.copyWith(errorMessage: 'Therapist ID is missing!'));
      return;
    }

    if (selectedDate == null) {
      emit(state.copyWith(errorMessage: 'Please select a date'));
      return;
    }

    List<String> slotsToSubmit = [];

    if (timeSlot != null) {
      slotsToSubmit = [timeSlot];
    } else if (multipleSlots != null && multipleSlots.isNotEmpty) {
      slotsToSubmit = multipleSlots;
    } else {
      emit(
        state.copyWith(errorMessage: 'Please select at least one time slot'),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await repository.submitTimesheet(
        therapistId: therapistId,
        date: selectedDate,
        timeSlots: slotsToSubmit,
      );

      final newSelected = List<String>.from(state.selectedTimeSlots)
        ..addAll(slotsToSubmit);

      emit(
        state.copyWith(
          isSubmitting: false,
          selectedTimeSlots: newSelected,
          selectedDate: selectedDate,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to submit timesheet',
        ),
      );
    }
  }
}
