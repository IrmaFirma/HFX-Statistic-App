import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Authentication/SignIn/SignInPage.dart';
import 'package:time_tracker/Components/PlatformAwareDialog.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:time_tracker/home/RecordListTile.dart';
import 'package:time_tracker/home/Records/EditRecordPage.dart';
import 'package:time_tracker/home/job_entries/RecordEntriesPage.dart';

import 'listItemsBuilder.dart';


class RecordsPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      appBar: AppBar(
        title: Text('Records',  style: TextStyle(color: Color(0xFFC6D5E9))),
        backgroundColor: Color(0xFF2A3040),
        leading: Container(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFFC6D5E9)),
            onPressed: () => EditRecordPage.show(context),
          )
        ],
      ),
      body: buildContent(context),
    );
  }

  Future<void> _delete(BuildContext context, Record record) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteRecord(record);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Widget buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Record>>(
      stream: database.recordsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Record>(
          snapshot: snapshot,
          itemBuilder: (context, record) => Dismissible(
            key: Key('record-${record.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, record),
            child: RecordListTile(
              record: record,
              onTap: () => RecordEntriesPage.show(context, record),
            ),
          ),
        );
      },
    );
  }
}