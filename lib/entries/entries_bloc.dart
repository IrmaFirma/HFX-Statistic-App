import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/home/Entry.dart';
import 'package:time_tracker/home/job_entries/Format.dart';
import 'daily_jobs_details.dart';
import 'entries_list_tile.dart';
import 'entry_job.dart';


class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<EntryRecord>> get _allEntriesStream => Rx.combineLatest2(
    database.entriesStream(),
    database.recordsStream(),
    _entriesJobsCombiner,
  );

  static List<EntryRecord> _entriesJobsCombiner(
      List<Entry> entries, List<Record> records) {
    return entries.map((entry) {
      final record = records.firstWhere(
            (record) => record.id == entry.recordId,
        orElse: () => null,
      );
      return EntryRecord(entry, record);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryRecord> allEntries) {
    if(allEntries.isEmpty){
      return [];
    }
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: '',
        isHeader: true,
        trailingText: '',
      ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: '',
          isHeader: false,
          trailingText: 'Created',
        ),
        for (RecordDetails jobDuration in dailyJobsDetails.recordsDetails)
          EntriesListTileModel(
              leadingText: jobDuration.name,
              middleText: '',
              isHeader: false,
              trailingText: 'Record'
          ),
      ]
    ];
  }
}