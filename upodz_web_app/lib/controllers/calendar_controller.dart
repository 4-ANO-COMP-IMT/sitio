class CalendarController {
  DateTime selectedDate = DateTime.now();

  void setDate(DateTime date) {
    selectedDate = date;
  }

  DateTime getDate() {
    return selectedDate;
  }
}
