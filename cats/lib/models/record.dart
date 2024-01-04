import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

//Kayıt İşlemlerini Veritabanına İşlerken Kullanılan Kayıt Modeli

class Record {
  late DateTime date;
  late String note;
  late String imagePath;
  late String result;

  Record({
    required this.date,
    required this.note,
    required this.imagePath,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'note': note,
      'imagePath': imagePath,
      'result': result,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      date: DateTime.parse(map['date']),
      note: map['note'],
      imagePath: map['imagePath'],
      result: map['result'],
    );
  }
}

class RecordListManager {
  late List<Record> records;

  RecordListManager() {
    records = [];
  }

  void addRecord(Record record) {
    records.add(record);
  }

  Future<void> saveRecords() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/records.json');
    final List<Map<String, dynamic>> recordsMapList =
        records.map((record) => record.toMap()).toList();
    final String recordsJson = jsonEncode(recordsMapList);
    await file.writeAsString(recordsJson);
  }

  Future<void> loadRecords() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/records.json');
    if (file.existsSync()) {
      final String recordsJson = await file.readAsString();
      final List<dynamic> recordsList = jsonDecode(recordsJson);
      records = recordsList.map((record) => Record.fromMap(record)).toList();
    }
  }

  void setRecords(List<Record> records) {}
}
