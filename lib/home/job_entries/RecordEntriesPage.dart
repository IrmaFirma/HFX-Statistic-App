import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/home/Records/EditRecordPage.dart';
import 'package:time_tracker/home/listItemsBuilder.dart';
import '../Entry.dart';
import 'EntryListItem.dart';
import 'EntryPage.dart';

class RecordEntriesPage extends StatelessWidget {
  const RecordEntriesPage({@required this.database, @required this.record});

  final Database database;
  final Record record;

  static Future<void> show(BuildContext context, Record record) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) =>
            RecordEntriesPage(database: database, record: record),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
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
        title: Text(record.name, style: TextStyle(color: Color(0xFFC6D5E9))),
        backgroundColor: Color(0xFF2A3040),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFFC6D5E9)),
            onPressed: () => EntryPage.show(
                context: context, database: database, record: record),
          ),
        ],
      ),
      body: _buildContent(context, record),
    );
  }

  Widget _buildContent(BuildContext context, Record record) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(record: record),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              record: record,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                record: record,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
