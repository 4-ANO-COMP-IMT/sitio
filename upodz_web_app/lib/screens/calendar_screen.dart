import 'package:flutter/material.dart';
import '../widgets/custom_calendar.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
      ),
      body: Center(
        child: CustomCalendar(),
      ),
    );
  }
}
