import 'package:flutter/material.dart';

import '../../database/user.dart';
import '../../database/user_account.dart';
import '../../database/user_transaction.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/utils.dart';

class ScheduleView extends StatefulWidget {
  final User userTo;
  final UserTransaction userTransaction;
  final List<UserAccount> listUserAccount;

  const ScheduleView({super.key, required this.userTo, required this.userTransaction, required this.listUserAccount});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.clear,
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            'Para qual dia deseja agendar o pagamento?',
            style: Theme.of(context).textTheme.headline1,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 40)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Você está transferindo ', style: Theme.of(context).textTheme.bodyText2),
                TextSpan(text: putCurrencyMask(widget.userTransaction.value), style: Theme.of(context).textTheme.headline1),
                TextSpan(text: ' para ', style: Theme.of(context).textTheme.bodyText2),
                TextSpan(text: widget.userTo.name, style: Theme.of(context).textTheme.headline1),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          _tableCalendar(),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          _elevatedButtonSelectDate()
        ],
      ),
    );
  }

  TableCalendar _tableCalendar() {
    return TableCalendar(
      headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
      calendarStyle: CalendarStyle(
          selectedTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor)),
      firstDay: DateTime.now(),
      lastDay: DateTime(2050, 01, 01),
      focusedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      locale: 'pt_BR',
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
    );
  }

  ElevatedButton _elevatedButtonSelectDate() {
    return ElevatedButton(
        key: const Key('buttonSelectDate'),
        onPressed: () {
          setState(() {
            Navigator.pop(context, _selectedDay);
          });
        },
        child: const Text('Selecionar Data'));
  }
}
