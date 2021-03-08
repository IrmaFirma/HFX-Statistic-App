import 'package:flutter/foundation.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.recordId,
    @required this.start,
    @required this.end,
    @required this.endBalance,
    @required this.startBalance,
    @required this.income,
    @required this.turnover,
    this.lostTrades,
    this.wonTrades,
    this.trades
  });

  String id;
  String recordId;
  DateTime start;
  DateTime end;
  String endBalance;
  String startBalance;
  String trades;
  String wonTrades;
  String lostTrades;
  String income;
  String turnover;


  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Entry(
      id: id,
      recordId: value['recordId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      endBalance: value['endBalance'],
      startBalance: value['startBalance'],
      turnover: value['turnover'],
      trades: value['trades'],
      wonTrades: value['wonTrades'],
      lostTrades: value['lostTrades'],
      income: value['income'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recordId': recordId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'endBalance':endBalance,
      'startBalance':startBalance,
      'turnover':turnover,
      'trades':trades,
      'wonTrades':wonTrades,
      'lostTrades':lostTrades,
      'income':income
    };
  }
}