import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/home/Entry.dart';


class EntryRecord {
  EntryRecord(this.entry, this.record);

  final Entry entry;
  final Record record;
}