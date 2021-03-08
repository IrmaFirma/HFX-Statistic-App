import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/home/Entry.dart';
import 'package:time_tracker/logic.dart';
import 'DateTimePicker.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({@required this.database, @required this.record, this.entry});

  final Record record;
  final Entry entry;
  final Database database;

  static Future<void> show(
      {BuildContext context,
      Database database,
      Record record,
      Entry entry}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, record: record, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _endBalance;
  String _startBalance;
  String _trades;
  String _wonTrades;
  String _lostTrades;
  String _income;
  String _turnover;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _endBalance = widget.entry?.endBalance ?? '';
    _startBalance = widget.entry?.startBalance ?? '';
    _income = widget.entry?.income ?? '';
    _wonTrades = widget.entry?.wonTrades ?? '';
    _lostTrades = widget.entry?.lostTrades ?? '';
    _turnover = widget.entry?.turnover ?? '';
    _trades = widget.entry?.trades ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
        id: id,
        recordId: widget.record.id,
        start: start,
        end: end,
        endBalance: _endBalance,
        startBalance: _startBalance,
        income: _income,
        turnover: _turnover,
        trades: _trades,
        wonTrades: _wonTrades,
        lostTrades: _lostTrades);
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.record.name, style: TextStyle(color: Color(0xFFC6D5E9)),),
        backgroundColor: Color(0xFF2A3040),
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: TextStyle(fontSize: 18.0, color: Color(0xFFC6D5E9)),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 520,
          padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
          child: Card(
            color: Color(0xFFC6D5E9),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    _buildStartBalance(),
                    SizedBox(width: 18),
                    _buildEndBalance(),
                  ]),
                  _buildTurnover(),
                  _buildTrades(),
                  Row(children: [
                    _buildWonTrades(),
                    SizedBox(width: 18),
                    _buildLostTrades()
                  ]),
                  _buildIncome()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      selectDate: (date) => setState(() => _startDate = date),
      selectTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      selectDate: (date) => setState(() => _endDate = date),
      selectTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildEndBalance() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 20,
        controller: TextEditingController(text: _endBalance),
        decoration: InputDecoration(
          labelText: 'End Balance',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: null,
        onChanged: (endBalance) {
          _endBalance = endBalance;
          return EndB = double.parse(endBalance);
        },
      ),
    );
  }

  Widget _buildStartBalance() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 20,
        controller: TextEditingController(text: _startBalance),
        decoration: InputDecoration(
          labelText: 'Start Balance',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: null,
        onChanged: (startBalance) {
          _startBalance = startBalance;
          return StartB = double.parse(startBalance);
        },
      ),
    );
  }

  Widget _buildTurnover() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 20,
      controller: TextEditingController(text: _turnover),
      decoration: InputDecoration(
        labelText: 'Turnover',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20, color: Colors.black),
      maxLines: null,
      onChanged: (turnover) {
        _turnover = turnover;
        return Turnover = double.parse(turnover);
      },
    );
  }

  Widget _buildTrades() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 20,
      controller: TextEditingController(text: _trades),
      decoration: InputDecoration(
        labelText: 'Total Trades',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20, color: Colors.black),
      maxLines: null,
      onChanged: (trades) {
        _trades = trades;
        return Trades = int.parse(trades);
      },
    );
  }

  Widget _buildWonTrades() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 20,
        controller: TextEditingController(text: _wonTrades),
        decoration: InputDecoration(
          labelText: 'Won Trades',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: null,
        onChanged: (wonTrades) {
          _wonTrades = wonTrades;
          return WonT = int.parse(wonTrades);
        },
      ),
    );
  }

  Widget _buildLostTrades() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 20,
        controller: TextEditingController(text: _lostTrades),
        decoration: InputDecoration(
          labelText: 'Lost Trades',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: null,
        onChanged: (lostTrades) {
          _lostTrades = lostTrades;
          return LostT = int.parse(lostTrades);
        },
      ),
    );
  }

  Widget _buildIncome() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 20,
      controller: TextEditingController(text: _income),
      decoration: InputDecoration(
        labelText: 'Income',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20, color: Colors.black),
      maxLines: null,
      onChanged: (income) {
        _income = income;
        return Income = double.parse(income);
      },
    );
  }
}
