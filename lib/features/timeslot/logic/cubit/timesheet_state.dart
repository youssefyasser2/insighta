import 'package:equatable/equatable.dart';
import 'package:test_app/features/therapy/domain/entities/therapist.dart';

class TimesheetState extends Equatable {
  final DateTime? selectedDate;
  final List<String> selectedTimeSlots;
  final DateTime currentWeekStart;
  final Therapist therapist;
  final bool isSubmitting;
  final String? errorMessage;

  const TimesheetState({
    this.selectedDate,
    required this.selectedTimeSlots,
    required this.currentWeekStart,
    required this.therapist,
    this.isSubmitting = false,
    this.errorMessage,
  });

  TimesheetState copyWith({
    DateTime? selectedDate,
    List<String>? selectedTimeSlots,
    DateTime? currentWeekStart,
    Therapist? therapist,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return TimesheetState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlots: selectedTimeSlots ?? this.selectedTimeSlots,
      currentWeekStart: currentWeekStart ?? this.currentWeekStart,
      therapist: therapist ?? this.therapist,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  // ✅ Getter جديد
  bool get hasError => errorMessage != null;

  // ✅ Getter جديد
  bool isTimeSlotSelected(String slot) {
    return selectedTimeSlots.contains(slot);
  }

  @override
  List<Object?> get props => [
        selectedDate,
        selectedTimeSlots,
        currentWeekStart,
        therapist,
        isSubmitting,
        errorMessage,
      ];
}