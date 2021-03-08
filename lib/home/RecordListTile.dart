import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/Models/Record.dart';


class RecordListTile extends StatelessWidget {
  RecordListTile({@required this.record, this.onTap});
  final Record record;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(record.name, style: TextStyle(color: Color(0xFFC6D5E9)),),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right, color: Color(0xFFC6D5E9),),
    );
  }
}