// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_final_fields, deprecated_member_use, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Detection App',
    home: DetectionPage(),
  ));
}

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  List<File> _images = [];
  final picker = ImagePicker();

   Future<void> getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _images.add(File(pickedFile.path));
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: ${e.toString()}');
    }
  }

  void deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _onDetectPressed() {
    if (_images.isEmpty) {
      // Show error if no image is uploaded
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please upload an image first.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Check if data is entered
      bool isDataEntered =
          EnterDataPage.patientNameController.text.isNotEmpty &&
              EnterDataPage.genderController.text.isNotEmpty &&
              EnterDataPage.ageController.text.isNotEmpty &&
              EnterDataPage.dateController.text.isNotEmpty &&
              EnterDataPage.doctorNameController.text.isNotEmpty &&
              EnterDataPage.notesController.text.isNotEmpty;

      if (!isDataEntered) {
        // Show error if data is not entered
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Please enter all required data.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Navigate to ResultPage with entered data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              patientName: EnterDataPage.patientNameController.text,
              gender: EnterDataPage.genderController.text,
              age: EnterDataPage.ageController.text,
              date: EnterDataPage.dateController.text,
              doctorName: EnterDataPage.doctorNameController.text,
              notes: EnterDataPage.notesController.text,
              images: _images,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: const Text(
          'Detection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/Animation - 1711930901295.json', // Replace with your animation JSON file path
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please DR, Upload Your CT images To Detect',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: ()  {
                    getImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  label: const Text(
                    'Upload from Gallery',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EnterDataPage()),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Enter Data',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                _images.isNotEmpty
                    ? Column(
                  children: [
                    Text(
                      'Files Uploaded: ${_images.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                          Text(_images[index].path.split('/').last),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteImage(index);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )
                    : Container(),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    _onDetectPressed(); // Call the custom detection function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Detect',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnterDataPage extends StatelessWidget {
  static final TextEditingController patientNameController =
  TextEditingController();
  static final TextEditingController genderController = TextEditingController();
  static final TextEditingController ageController = TextEditingController();
  static final TextEditingController dateController = TextEditingController();
  static final TextEditingController doctorNameController =
  TextEditingController();
  static final TextEditingController notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  EnterDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Enter Data',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Enter Data',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: patientNameController,
                        decoration: const InputDecoration(
                          labelText: 'Patient Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Patient Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: genderController,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: doctorNameController,
                        decoration: const InputDecoration(
                          labelText: 'Doctor Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Doctor Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Notes';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('Message'),
                                  content: Text(
                                    'Thanks! The Data was entered successfully!',
                                  ),
                                );
                              },
                            );

                            Future.delayed(const Duration(seconds: 4), () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(
                                  context); // Navigate back to DetectionPage
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String patientName;
  final String gender;
  final String age;
  final String date;
  final String doctorName;
  final String notes;
  final List<File> images;

  ResultPage({super.key, 
    required this.patientName,
    required this.gender,
    required this.age,
    required this.date,
    required this.doctorName,
    required this.notes,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'The Result',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDataField('Patient Name', patientName),
              _buildDataField('Gender', gender),
              _buildDataField('Age', age),
              _buildDataField('Date', date),
              _buildDataField('Doctor Name', doctorName),
              _buildDataField('Notes', notes),
              const SizedBox(height: 20),
              Text(
                'Files Uploaded: ${images.length}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(images[index].path.split('/').last),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}