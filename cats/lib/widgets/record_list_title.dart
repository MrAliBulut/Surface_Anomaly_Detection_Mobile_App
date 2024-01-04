import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Kayıtların Tutulduğu Listenin Genel Yapısını İfade Etmektedir.

class RecordListTile extends StatelessWidget {
  const RecordListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: ListTile(
          leading: Text(DateFormat('EEE, MMM d').format(DateTime.now())),
          title: Center(
            child: Text(
              "SONUÇ",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Kayıtları Silme İşlemleri
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
