import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyScheduleWidget extends StatefulWidget {
  @override
  _MyScheduleWidgetState createState() => _MyScheduleWidgetState();
}

class _MyScheduleWidgetState extends State<MyScheduleWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now(); // Set to today's date
  DateTime? _selectedDay = DateTime.now(); // Select today's date

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0), // Reduced margin
      padding: EdgeInsets.all(16.0), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Schedule',
            style: TextStyle(
              fontSize: 16.0, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          SizedBox(
            height: 390, // Constrain the calendar height
            child: TableCalendar(
              firstDay: DateTime.utc(2025, 7, 28),
              lastDay: DateTime.utc(2025, 12, 31), // Extended to include today and beyond
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                cellMargin: EdgeInsets.all(6.0), // Reduced cell margin
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, size: 16), // Reduced icon size
                rightChevronIcon: Icon(Icons.chevron_right, size: 16), // Reduced icon size
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) {
                  return Container(
                    margin: EdgeInsets.all(3.0), // Reduced margin
                    alignment: Alignment.center,
                    height: 15.0, // Reduced height
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(fontSize: 10.0), // Reduced font size
                    ),
                  );
                },
              ),
            ),
          ),
          // SizedBox(height: 5), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Colors.green, size: 15), // Reduced icon size
              SizedBox(width: 2),
              Text('Attend Classes', style: TextStyle(fontSize: 10)), // Reduced font size
              SizedBox(width: 15), // Reduced spacing
              Icon(Icons.close, color: Colors.red, size: 15), // Reduced icon size
              SizedBox(width: 2),
              Text('Missed Classes', style: TextStyle(fontSize: 10)), // Reduced font size
              SizedBox(width: 10), // Reduced spacing
              Icon(Icons.circle, color: Colors.blue, size: 12), // Reduced icon size
              SizedBox(width: 2),
              Text('Upcoming Classes', style: TextStyle(fontSize: 10)), // Reduced font size
            ],
          ),
        ],
      ),
    );
  }
}