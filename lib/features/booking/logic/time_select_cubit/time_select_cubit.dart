import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app/features/booking/logic/date_select_cubit/date_select_cubit.dart';

part 'time_select_state.dart';

class TimeSelectCubit extends Cubit<TimeSelectState> {
  final DateSelectCubit dateSelectCubit;

  TimeSelectCubit({required this.dateSelectCubit})
      : super(TimeSelectInitial()) {
    generateTime();
  }

  void generateTime() {
    emit(TimeSelectLoading());

    final dateState = dateSelectCubit.state;
    if (dateState is! DateSelectLoaded) {
      emit(TimeSelectInitial());
      return;
    }

    final selectedDate = dateState.dates[dateState.selectedIndex];

    final now = DateTime.now();
    final isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    List<String> morning = _generateTimeRange(9, 13, isToday, now, selectedDate);
    List<String> afternoon = _generateTimeRange(13, 17, isToday, now, selectedDate);
    List<String> evening = _generateTimeRange(17, 21, isToday, now, selectedDate);

    emit(TimeSelectLoaded(
      morningSlots: morning,
      afternoonSlots: afternoon,
      eveningSlots: evening,
    ));
  }

  List<String> _generateTimeRange(int startHour, int endHour, bool isToday,
      DateTime now, DateTime selectedDate) {
    List<String> result = [];
    for (int hour = startHour; hour < endHour; hour++) {
      final slotTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
      );
      if (isToday && slotTime.isBefore(now)) continue;
      result.add(DateFormat.jm().format(slotTime));
    }
    return result;
  }

  void selectTime(String time) {
    if (state is TimeSelectLoaded) {
      emit((state as TimeSelectLoaded).copyWith(selectedTime: time));
    }
  }
}