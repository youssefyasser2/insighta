class TimesheetRepository {
  Future<void> submitTimesheet({
    required String therapistId,
    required DateTime date,
    required List<String> timeSlots,
  }) async {
    // Implement backend API call or local storage
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  }

  Future<List<String>> fetchAvailableTimeSlots(DateTime date) async {
    // Fetch available time slots from backend
    return [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '12:00 PM',
      '12:30 PM',
      '01:00 PM',
      '01:30 PM',
      '02:00 PM',
      '02:30 PM',
      '06:00 PM',
      '06:30 PM',
      '07:00 PM',
      '07:30 PM',
      '08:00 PM',
      '08:30 PM',
    ];
  }
}
