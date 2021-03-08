import 'package:flutter/material.dart';

class Record {
  final String name;
  final String id;
  Record({@required this.name, this.id});

  factory Record.fromMap(Map<String, dynamic> data, String documentId){
    if(data == null){
      return null;
    }
    final String name = data['name'];
    return Record(name: name, id: documentId);
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name
    };
  }
}