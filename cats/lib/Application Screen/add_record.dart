/*
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';
import '../main.dart';
import '../models/record.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  DateTime? _selectedDate = DateTime.now();
  XFile? _selectedImage;
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  late CameraImage cameraImage;
  late TextEditingController noteController;
  late RecordListManager recordListManager;
  late List<String> results;

  //Modelin İşlenme Safhalarını ve Not Düzenlemelerini İçermektedir.
  @override
  void initState() {
    super.initState();
    loadModel();
    noteController = TextEditingController();
  }

  //Modelin Yüklenme İşlemleri İçermektedir
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/metal_defects_model4.tflite',
      labels: 'assets/Metal_Yuzey.txt',
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  //Yüklenmiş Olan Modelin Nesneler Üzerindeki İşlemleri İçermektedir.
  Future<void> makePrediction() async {
    results = [];

    if (_selectedImage != null) {
      var recognitions = await Tflite.runModelOnImage(
        path: _selectedImage!.path,
        numResults: 2,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          results.add("${recognitions[0]['label']}");
        });
      } else {
        setState(() {
          results.add("Sonuç Bulunamadı");
        });
      }
    }
  }

  // Galeriden veya Kameradan Alınacak Görselin Seçim İşlemleri
  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 800, // Adjust the maxHeight and maxWidth as needed
      maxWidth: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = XFile(image.path);
      });
    }
  }

  //Seçilen Fotoğrafı Veritabanına Yazma İşlemleri
  void libraryUpload() async {
    if (_selectedImage != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("user")
          .child("sonuclar")
          .child("${noteController.text}.png");

      UploadTask uploadTask = ref.putFile(File(_selectedImage!.path));

      TaskSnapshot snapshot = await uploadTask;

      var url = await snapshot.ref.getDownloadURL();
      debugPrint("upload edilen resmin urlsi : " + url);
    } else {
      debugPrint("No image selected to upload.");
    }
  }

  //Kayıtların Veri Tabanına Kayıt İşlemlerini İçermektedir.
  Future<void> _saveDataToFirebase() async {
    if (_selectedDate != null &&
        noteController.text.isNotEmpty &&
        results.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('sonuclar').add({
          'date': _selectedDate,
          'note': noteController.text,
          'result': results[0], // Assuming you only save the first result
        });

        // Clear the form after saving
        setState(() {
          _selectedDate = DateTime.now();
          noteController.clear();
          _selectedImage = null;
          results.clear();
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved to Firebase')),
        );
      } catch (e) {
        print('Error saving data: $e');
        // Handle the error accordingly
      }
    } else {
      // Show an error message if any of the required fields is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false,
        title: Text("Add New Record",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1800),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 40,
                        ),
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('EEE, MMM d')
                                    .format(_selectedDate!)
                                : 'Select Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Note",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: noteController,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your note here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Photo Library'),
                              onTap: () async {
                                await _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                              onTap: () async {
                                await _pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Photo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _selectedImage != null
                            ? Image.file(File(_selectedImage!.path))
                            : Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await makePrediction();
                  libraryUpload();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Prediction Results'),
                        content: SingleChildScrollView(
                          child: Column(
                            children:
                                results.map((result) => Text(result)).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  await _saveDataToFirebase();
                },
                child: Text("SAVE"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                  fixedSize: Size(200, 70),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {
      Tflite.close();
    } catch (e) {
      print("Error closing TFLite: $e");
    }
    super.dispose();
  }
}
*/

/*
* "Facade" tasarım deseni kullanılarak karmaşık alt sistemleri (örneğin kamera, model tahmini, Firebase entegrasyonu) basitleştiren ve
* istemci kodunu daha kullanıcı dostu hale getiren bir sınıf olan RecordFacade'i içerir.
*/
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';
import '../main.dart';
import '../models/record.dart';

class RecordFacade {
  late CameraController cameraController;
  late TextEditingController noteController;
  late RecordListManager recordListManager;
  late BuildContext context;

  RecordFacade(BuildContext context) {
    this.context = context;
    loadModel();
    noteController = TextEditingController();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/metal_defects_model4.tflite',
      labels: 'assets/Metal_Yuzey.txt',
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<void> makePrediction(
      XFile? selectedImage, List<String> results) async {
    results.clear();

    if (selectedImage != null) {
      var recognitions = await Tflite.runModelOnImage(
        path: selectedImage.path,
        numResults: 2,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        results.add("${recognitions[0]['label']}");
      } else {
        results.add("Sonuç Bulunamadı");
      }
    }
  }

  Future<void> libraryUpload(XFile? selectedImage) async {
    if (selectedImage != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("user")
          .child("sonuclar")
          .child("${noteController.text}.png");

      UploadTask uploadTask = ref.putFile(File(selectedImage.path));

      TaskSnapshot snapshot = await uploadTask;

      var url = await snapshot.ref.getDownloadURL();
      debugPrint("upload edilen resmin urlsi : " + url);
    } else {
      debugPrint("No image selected to upload.");
    }
  }

  Future<void> saveDataToFirebase(
      DateTime? selectedDate, String note, List<String> results) async {
    if (selectedDate != null && note.isNotEmpty && results.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('sonuclar').add({
          'date': selectedDate,
          'note': note,
          'result': results[0],
        });

        noteController.clear();
        results.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved to Firebase')),
        );
      } catch (e) {
        print('Error saving data: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
}

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  DateTime? _selectedDate = DateTime.now();
  XFile? _selectedImage;
  late List<String> results;
  late RecordFacade recordFacade;

  @override
  void initState() {
    super.initState();
    recordFacade = RecordFacade(context);
    results = [];
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = XFile(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false,
        title: Text(
          "Add New Record",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1800),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 40,
                        ),
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('EEE, MMM d')
                                    .format(_selectedDate!)
                                : 'Select Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Note",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: recordFacade.noteController,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your note here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Photo Library'),
                              onTap: () async {
                                await _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                              onTap: () async {
                                await _pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Photo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _selectedImage != null
                            ? Image.file(File(_selectedImage!.path))
                            : Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await recordFacade.makePrediction(_selectedImage, results);
                  recordFacade.libraryUpload(_selectedImage);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Prediction Results'),
                        content: SingleChildScrollView(
                          child: Column(
                            children:
                                results.map((result) => Text(result)).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );

                  await recordFacade.saveDataToFirebase(
                      _selectedDate, recordFacade.noteController.text, results);
                },
                child: Text("SAVE"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                  fixedSize: Size(200, 70),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {
      Tflite.close();
    } catch (e) {
      print("Error closing TFLite: $e");
    }
    super.dispose();
  }
}
