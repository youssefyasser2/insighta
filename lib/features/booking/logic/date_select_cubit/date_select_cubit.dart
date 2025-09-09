import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'date_select_state.dart';

class DateSelectCubit extends Cubit<DateSelectState> {
  DateSelectCubit() : super(DateSelectInitial()) {
    loadDates();
  }

  Future<void> loadDates() async {
    emit(DateSelectLoading());
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final dates = _generateDateRange();
      emit(DateSelectLoaded(
        selectedIndex: 0,
        dates: dates,
        availableDates: _getAvailableDates(dates),
      ));
    } catch (e) {
      emit(DateSelectError('Failed to load dates: ${e.toString()}'));
    }
  }

  void selectDate(int index) {
    final currentState = state;
    if (currentState is DateSelectLoaded) {
      emit(DateSelectLoaded(
        selectedIndex: index,
        dates: currentState.dates,
        availableDates: currentState.availableDates,
      ));
    }
  }

  List<DateTime> _generateDateRange() {
    final today = DateTime.now();
    return List.generate(14, (i) => today.add(Duration(days: i)));
  }

  List<bool> _getAvailableDates(List<DateTime> dates) {
    return dates.map((date) => date.weekday != DateTime.sunday).toList();
  }
}
