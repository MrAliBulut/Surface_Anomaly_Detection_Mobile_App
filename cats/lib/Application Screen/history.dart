import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Firebase /record_firebase.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreServices firestore = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore.getRecords(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>>? note = snapshot.data;

            // Sort the list alphabetically based on the 'note' field
            note!.sort((a, b) => a['note'].compareTo(b['note']));

            return ListView.builder(
              itemCount: note.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime eklenisTarihi = DateTime.now(); // Default value

                if (note[index]['Ekleniş Tarihi'] != null) {
                  eklenisTarihi =
                      (note[index]['Ekleniş Tarihi'] as Timestamp).toDate();
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: ListTile(
                    title: Text(note[index]['note']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete button press
                        _showDeleteConfirmationDialog(note[index]['id']);
                      },
                    ),
                    onTap: () {
                      // Handle item tap
                      _showRecordDetailsDialog(note[index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  //Veri Tabanında Bulunan Kayıtları Getirme ve Görüntüleme İşlemleri
  Future<void> _showRecordDetailsDialog(Map<String, dynamic> record) async {
    // Kullanıcının girdiği not değeri
    String note = record['note'];

    // Firebase Storage'dan resmi getir
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user")
        .child("sonuclar")
        .child("$note.png");

    String imageUrl = await ref.getDownloadURL();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Record Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Note: $note'),
                Text('Date: ${_formatDate(record['date'])}'),
                Text('Result: ${record['result']}'),
                Text('Photo:'),
                // Eklenen kısım: Resmi görüntülemek için bir Image widget'i
                Image.network(imageUrl),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Inout Alınan Tarih Formatının Düzenleme İşlemleri
  String _formatDate(dynamic date) {
    if (date != null && date is Timestamp) {
      DateTime dateTime = date.toDate();
      // Customize the date format as per your requirements
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else {
      return 'Not available';
    }
  }

  //Kayıtları Silme İşlemleri
  Future<void> _showDeleteConfirmationDialog(String recordId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await firestore.deleteRecord(recordId);
                Navigator.of(context).pop();

                // Trigger a rebuild of the widget tree to reflect the changes
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
