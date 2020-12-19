import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project2/textInput.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 1, 6): ['Epiphany'],
  DateTime(2021, 2, 14): ['Valentine\'s Day'],
  DateTime(2021, 4, 21): ['Easter Sunday'],
  DateTime(2021, 4, 22): ['Easter Monday'],
};

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  final String actualTask;

  MyHomePage({this.actualTask});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime noww = new DateTime.now();
  DateTime dayy;

  @override
  void initState() {
    dayy = new DateTime(noww.year, noww.month, noww.day);
    super.initState();

    print(dayy);

    DateTime now = new DateTime.now();
    final DateTime _selectedDay = new DateTime(now.year, now.month, now.day);

    _events = {
      DateTime.parse("2020-11-18 12:00:00.000Z"): [
        'Event A0',
        'Event B0',
        'Event C0',
      ],
      DateTime.parse("2020-11-23 12:00:00.000Z"): [
        'Event A2',
        'Event B2',
      ],
      DateTime.parse("2020-11-13 12:00:00.000Z"): [
        'Event A4',
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    dayy = day;

    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          addItem();
        },
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.black,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.black, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.orange[700],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.3,
              child: Container(
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      offset: Offset(0, 9),
                      blurRadius: 20,
                      spreadRadius: 1)
                ]),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.deepOrange, width: 4)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: 50,
                      width: 5,
                      color: Colors.deepOrange,
                    )
                  ],
                ),
              ),
              secondaryActions: [
                IconSlideAction(
                  caption: "Done",
                  color: Colors.blue,
                  icon: Icons.check,
                  onTap: () {
                    removeItem(event);
                  },
                )
              ],
            ),
          )
          .toList(),
    );
  }

  void removeItem(event) {
    setState(() {
      _events[dayy].remove(event);
    });
  }

  void addItem() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return TxtIn();
      })).then((data) {
        if (_events[dayy] == null) {
          _events[dayy] = [];
        }
        if (data.isNotEmpty) {
          _events[dayy].add(data);
          print(_events[dayy]);
        }
      });
    });
  }
}
