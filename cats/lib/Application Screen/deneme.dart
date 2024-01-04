/*
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  DateTime? _selectedDate = DateTime.now();
  PickedFile? _selectedImage;
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  late CameraImage cameraImage;

  /*
  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

   */

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: 'assets/metal_defects_model.tflite',
        labels: 'assets/Metal_Yuzey.txt',
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false);
  }

  Future<void> makePrediction() async {
    if (_selectedImage != null) {
      var recognitions = await Tflite.runModelOnImage(
        path: _selectedImage!.path,
        numResults: 2, // İstenen sınıf sayısı
      );

      // Tahmin sonuçları burada kullanılabilir
      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          result = "Prediction: ${recognitions[0]['label']}";
        });
      }
    }
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            cameraImage = imageFromStream;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[700],
          automaticallyImplyLeading: false,
          title: Text("Add New Record",
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Diğer bileşenler buraya eklenir...

            ElevatedButton(
              onPressed: () {
                //makePrediction(); // Tahmin yapma fonksiyonu
                // Diğer işlemleri ekleyebilirsiniz
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
    );
  }

  /*
  @override
  void dispose() {
    Tflite.close();
    cameraController.dispose();
    super.dispose();
  }

   */
}

 */
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  DateTime? _selectedDate = DateTime.now(); //Alındı
  PickedFile? _selectedImage; //Alındı
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  late CameraImage cameraImage;

  //Buraya Kadar Alındı
  @override
  void initState() {
    super.initState();
    //initCamera();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: 'assets/metal_defects_model.tflite',
        labels: 'assets/Metal_Yuzey.txt',
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false);
  }

  //Buraya Kadar Alındı
  Future<void> makePrediction() async {
    if (_selectedImage != null) {
      var recognitions = await Tflite.runModelOnImage(
        path: _selectedImage!.path,
        numResults: 2, // İstenen sınıf sayısı
      );

      // Tahmin sonuçları burada kullanılabilir
      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          result = "Prediction: ${recognitions[0]['label']}";
        });
      }
    }
  }

  /*
  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = imageFromStream,
                }
            });
      });
    });
  }
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[700],
          automaticallyImplyLeading: false,
          title: Text("Add New Record",
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Diğer bileşenler buraya eklenir...

            ElevatedButton(
              onPressed: () {
                //makePrediction(); // Tahmin yapma fonksiyonu
                // Diğer işlemleri ekleyebilirsiniz
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
    );
  }

  @override
  void dispose() {
    Tflite.close();
    //cameraController.dispose();
    super.dispose();
  }
}

/*

-> Kayıt Etnme İşlemleri
class AddRecord extends StatelessWidget {
  final RecordsController recordsController = Get.find();

  final TextEditingController noteController = TextEditingController();

  final Rx<DateTime?> selectedDate = DateTime.now().obs;
  final Rx<PickedFile?> selectedImage = Rx<PickedFile?>(null);

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      selectedImage(image as PickedFile?);
    }
  }

  void saveRecord() {
    if (selectedDate.value != null && noteController.text.isNotEmpty) {
      Record newRecord = Record(
        date: selectedDate.value!,
        note: noteController.text,
        imagePath: selectedImage.value?.path,
      );

      recordsController.addRecord(newRecord);

      // Clear the selected date, note, and image after saving
      selectedDate(DateTime.now());
      noteController.clear();
      selectedImage(null);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value ?? DateTime.now(),
                  firstDate: DateTime(1800),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  selectedDate(pickedDate);
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
                        child: Obx(() {
                          return Text(
                            selectedDate.value != null
                                ? DateFormat('EEE, MMM d')
                                    .format(selectedDate.value!)
                                : 'Select Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
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
                            onTap: () {
                              pickImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Camera'),
                            onTap: () {
                              pickImage(ImageSource.camera);
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
                      Obx(() {
                        return selectedImage.value != null
                            ? Image.file(File(selectedImage.value!.path!))
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
                              );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                saveRecord();
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
    );
  }
}
*/
/*
-> Derlenmiş Uygulama Ekranı Add Record
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';
import '../main.dart';

//-> Genel Uygulamamız

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  DateTime? _selectedDate = DateTime.now();
  PickedFile? _selectedImage;
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  late CameraImage cameraImage;

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = image as PickedFile?;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //initCamera();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: 'assets/metal_defects_model.tflite',
        labels: 'assets/Metal_Yuzey.txt',
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false);
  }

  Future<void> makePrediction() async {
    if (_selectedImage != null) {
      var recognitions = await Tflite.runModelOnImage(
        path: _selectedImage!.path,
        numResults: 2, // İstenen sınıf sayısı
      );

      // Tahmin sonuçları burada kullanılabilir
      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          result = "Prediction: ${recognitions[0]['label']}";
        });
      }
    }
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = imageFromStream,
                }
            });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false, // Bu satır geri butonunu kaldırır
        title: Text("Add New Record",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
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
                  height: 60, // Tarih kartının yüksekliği
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 40,
                      ),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('EEE, MMM d').format(_selectedDate!)
                              : 'Select Date',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20, // Yazı boyutu
                            fontWeight: FontWeight.bold, // Kalınlık
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
                      maxLines: null,
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
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Camera'),
                            onTap: () {
                              _pickImage(ImageSource.camera);
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
              onPressed: () {
                // SAVE button pressed
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
    );
  }

  @override
  void dispose() {
    Tflite.close();
    //cameraController.dispose();
    super.dispose();
  }
}

*/

/*
-> Derlenmiş Uygulama Add Record Secrenn 2

import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = XFile(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/metal_defects_model.tflite',
      labels: 'assets/Metal_Yuzey.txt',
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  late List<String> results;

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

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = imageFromStream,
                }
            });
      });
    });
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
                              ? DateFormat('EEE, MMM d').format(_selectedDate!)
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
                      maxLines: null,
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
                // Show the result in a pop-up window
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
-> History Ekranı
import 'package:flutter/material.dart';
import '../widgets/record_list_title.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false, // Bu satır geri butonunu kaldırır
        centerTitle: true,
        title: Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          RecordListTile(),
          RecordListTile(),
          RecordListTile(),
          RecordListTile(),
          RecordListTile(),
          RecordListTile(),
          RecordListTile(),
          RecordListTile(),
          RecordListTile()
        ],
      ),
    );
  }
}
*/

/*
*-> Recor List Tile
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
*/

/*
* En son add record ekranı
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void initState() {
    super.initState();
    loadModel();
    noteController = TextEditingController();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/metal_defects_model2.tflite',
      labels: 'assets/Metal_Yuzey.txt',
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

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

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = XFile(image.path);
      });
    }
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = imageFromStream,
                }
            });
      });
    });
  }

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
                              ? DateFormat('EEE, MMM d').format(_selectedDate!)
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
-> xml kodu
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera" />
    <!-- Opsiyonel olarak depolama izinleri ekleyebilirsiniz -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <application
        android:label="cats"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
                />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />

        <!-- TensorFlow Lite kütüphanesi -->
        <uses-library
            android:name="org.tensorflow.lite"
            android:required="false" />
    </application>
</manifest>
*/

/*
* xml 2
* <manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Kamera izni -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera" />

    <!-- Opsiyonel olarak depolama izinleri -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <application
        android:label="cats"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Ana Aktivite -->
        <activity
            android:name="io.flutter.embedding.android.FlutterActivity"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale"
            android:hardwareAccelerated="true"
            android:exported="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
                android:name="io.flutter.app.android.SplashScreenUntilFirstFrame"
                android:value="true" />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- Flutter gömülü tema -->
        <meta-data
            android:name="io.flutter.embedding.android.NormalTheme"
            android:resource="@style/NormalTheme" />

        <!-- Flutter gömülü tema -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />

        <!-- TensorFlow Lite kütüphanesi -->
        <uses-library
            android:name="org.tensorflow.lite"
            android:required="false" />
    </application>
</manifest>*/

/*
 son add record
    import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void initState() {
    super.initState();
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

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = XFile(image.path);
      });
    }
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = imageFromStream,
                }
            });
      });
    });
  }

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
                              ? DateFormat('EEE, MMM d').format(_selectedDate!)
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

-> History son ekran
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Firebase /record_firebase.dart'; // Update the import path if needed

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

            // ...

            return ListView.builder(
              itemCount: note!.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime eklenisTarihi = DateTime.now(); // Default value

                if (note[index]['Ekleniş Tarihi'] != null) {
                  eklenisTarihi =
                      (note[index]['Ekleniş Tarihi'] as Timestamp).toDate();
                }

                // Listeyi 'note' alanına göre alfabetik olarak sırala
                note.sort((a, b) => a['note'].compareTo(b['note']));

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

  String _formatDate(dynamic date) {
    if (date != null && date is Timestamp) {
      DateTime dateTime = date.toDate();
      // Customize the date format as per your requirements
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else {
      return 'Not available';
    }
  }

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
*/
