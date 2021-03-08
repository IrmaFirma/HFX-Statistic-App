import 'package:flutter/foundation.dart';
import 'entry_job.dart';


/// Temporary model class to store the time tracked and pay for a job
class RecordDetails {
  RecordDetails({
    @required this.name,
  });
  final String name;
}

/// Groups together all jobs/entries on a given day
class DailyJobsDetails {
  DailyJobsDetails({@required this.date, @required this.recordsDetails});
  final DateTime date;
  final List<RecordDetails> recordsDetails;


  /// splits all entries into separate groups by date
  static Map<DateTime, List<EntryRecord>> _entriesByDate(List<EntryRecord> entries) {
    Map<DateTime, List<EntryRecord>> map = {};
    for (var entryJob in entries) {
      final entryDayStart = DateTime(entryJob.entry.start.year,
          entryJob.entry.start.month, entryJob.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryJob];
      } else {
        map[entryDayStart].add(entryJob);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryJob into a list of DailyJobsDetails with date information
  static List<DailyJobsDetails> all(List<EntryRecord> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyJobsDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byJob = _jobsDetails(entriesByDate);
      list.add(DailyJobsDetails(date: date, recordsDetails: byJob));
    }
    return list.toList();
  }

  /// groups entries by job
  static List<RecordDetails> _jobsDetails(List<EntryRecord> entries) {
    Map<String, RecordDetails> recordDuration = {};
    for (var entryJob in entries) {
      final entry = entryJob.entry;
      if (recordDuration[entry.recordId] == null) {
        recordDuration[entry.recordId] = RecordDetails(
          name: entryJob.record.name,
        );
      }
    }
    return recordDuration.values.toList();
  }
}