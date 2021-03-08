import 'package:flutter/material.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/home/Entry.dart';
import 'package:time_tracker/logic.dart';

import 'Format.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.record,
    @required this.onTap,
  });

  final Entry entry;
  final Record record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(entry.start);
    final startDate = Format.date(entry.start);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek,
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFF2795C4),
              )),
          SizedBox(width: 15.0),
          Text(startDate,
              style: TextStyle(fontSize: 18.0, color: Color(0xFFC6D5E9))),
        ]),
        Row(children: <Widget>[
          Text('Creation time: $startTime',
              style: TextStyle(fontSize: 16.0, color: Color(0xFFC6D5E9))),
          Expanded(child: Container()),
        ]),
        Row(
          children: [
            Text(
                'Profit: ${profitMethod(income: double.parse(entry.income ), turnover: double.parse(entry.turnover)).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 13.0, color: Color(0xFF02B28C))),
            SizedBox(width: 10),
            Text(
                'Percent: ${percentMethod(profit: Profit, startBalance: double.parse(entry.startBalance)).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 13.0, color: Color(0xFFF7495C)))
          ],
        ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.record,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Record record;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        record: record,
        onTap: onTap,
      ),
    );
  }
}
