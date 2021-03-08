import 'dart:async';
import 'package:meta/meta.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/home/Entry.dart';

import 'APIPath.dart';
import 'FirestoreService.dart';


abstract class Database {
  Future<void> setRecord(Record record);
  Future<void> deleteRecord(Record record);
  Stream<List<Record>> recordsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Record record});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setRecord(Record record) async => await _service.setData(
    path: APIPath.record(uid, documentIdFromCurrentDate()),
    data: record.toMap(),
  );

  @override
  Future<void> deleteRecord(Record record) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(record: record).first;
    for (Entry entry in allEntries) {
      if (entry.recordId == record.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.record(uid, record.id));
  }

  //todo problem
  @override
  Stream<List<Record>> recordsStream() => _service.collectionStream(
    path: APIPath.records(uid),
    builder: (data, documentId) => Record.fromMap(data, documentId),
  );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
    path: APIPath.entry(uid: uid, entryId: entry.id),
    data: entry.toMap(),
  );

  @override
  Future<void> deleteEntry(Entry entry) async => await _service.deleteData(path: APIPath.entry(uid: uid, entryId: entry.id));

  @override
  Stream<List<Entry>> entriesStream({Record record}) => _service.collectionStream<Entry>(
    path: APIPath.entries(uid: uid),
    queryBuilder: record != null ? (query) => query.where('recordId', isEqualTo: record.id) : null,
    builder: (data, documentID) => Entry.fromMap(data, documentID),
    sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  );
}