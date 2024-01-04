import 'package:cloud_firestore/cloud_firestore.dart';

//Kayıtların Veri Tabanına Durumları İçin Tasarlanmış Olan Model
class FirestoreServices {
  final CollectionReference recordCollections =
      FirebaseFirestore.instance.collection('sonuclar');

  Future<List<Map<String, dynamic>>> getRecords() async {
    List<Map<String, dynamic>> sonuclar = [];

    try {
      QuerySnapshot querySnapshot = await recordCollections.get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> sonucData = doc.data() as Map<String, dynamic>;
        sonucData['id'] = doc.id; // Her belgeye id ekleniyor
        sonuclar.add(sonucData);
      });
    } catch (e) {
      print('Hata: $e');
    }

    return sonuclar;
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await recordCollections.doc(recordId).delete();
      print('Record deleted successfully');
    } catch (e) {
      print('Hata: $e');
    }
  }
}
