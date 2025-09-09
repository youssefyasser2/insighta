part of 'date_select_cubit.dart';

@immutable
abstract class DateSelectState {}

class DateSelectInitial extends DateSelectState {}

class DateSelectLoading extends DateSelectState {}

class DateSelectLoaded extends DateSelectState {
  final List<DateTime> dates;
  final List<bool> availableDates;
  final int selectedIndex;

  DateSelectLoaded({
    required this.dates,
    required this.availableDates,
    required this.selectedIndex,
  });
}

class DateSelectError extends DateSelectState {
  final String message;

  DateSelectError(this.message);
}
