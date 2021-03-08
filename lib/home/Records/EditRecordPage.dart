import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Components/PlatformAwareDialog.dart';
import 'package:time_tracker/Models/Record.dart';
import 'package:time_tracker/Services/Database.dart';

class EditRecordPage extends StatefulWidget {
  EditRecordPage({@required this.database, this.record});
  final Database database;
  final Record record;
  static Future<void> show(BuildContext context, {Record record}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => EditRecordPage(database: database, record: record), fullscreenDialog: true));
  }

  @override
  _EditRecordPageState createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;

  @override
  void initState(){
    super.initState();
    if (widget.record != null){
      _name = widget.record.name;
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  Future<void> _submit() async {
    if(_validateAndSave()){
      final records = await widget.database.recordsStream(  ).first;
      final allNames = records.map((record) => record.name).toList();
      if(allNames.contains(_name)){
        PlatformAwareDialog(
          title: 'Name already used',
          content: 'Please choose a different name',
          defaultActionText: 'OK',
        ).show(context);
      }else {
        final record = Record(name: _name);
        await widget.database.setRecord(record);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'New Record': 'Edit Record', style: TextStyle(color: Color(0xFFC6D5E9)),),
        actions: [
          FlatButton(
            child: Text('Save',
                style: TextStyle(fontSize: 18, color: Color(0xFFC6D5E9))),
            onPressed: _submit,
          ),
        ],
        backgroundColor: Color(0xFF2A3040),
        elevation: 2,
      ),
      body: _buildContent(),
      backgroundColor: Color(0xFF1F232E),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Color(0xFFC6D5E9),
          child:
          Padding(padding: const EdgeInsets.all(16.0), child: _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren()),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Record name',
        ),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can not be empty',
        onSaved: (value) => _name = value,
      )
    ];
  }
}