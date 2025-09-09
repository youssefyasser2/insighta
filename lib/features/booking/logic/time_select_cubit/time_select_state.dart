part of 'time_select_cubit.dart';


abstract class TimeSelectState {}

class TimeSelectInitial extends TimeSelectState {}

class TimeSelectLoading extends TimeSelectState {}

class TimeSelectLoaded extends TimeSelectState {
  final List<String> morningSlots;
  final List<String> afternoonSlots;
  final List<String> eveningSlots;
  final String? selectedTime;

  TimeSelectLoaded({
    required this.morningSlots,
    required this.afternoonSlots,
    required this.eveningSlots,
    this.selectedTime,
  });

  TimeSelectLoaded copyWith({
    List<String>? morningSlots,
    List<String>? afternoonSlots,
    List<String>? eveningSlots,
    String? selectedTime,
  }) {
    return TimeSelectLoaded(
      morningSlots: morningSlots ?? this.morningSlots,
      afternoonSlots: afternoonSlots ?? this.afternoonSlots,
      eveningSlots: eveningSlots ?? this.eveningSlots,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}