import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() =>
      _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState
    extends State<DiseaseDetectionScreen> {

  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {

    final XFile? image =
        await picker.pickImage(source: source);

    if (image != null) {

      setState(() {
        selectedImage = File(image.path);
      });

    }
  }

  void analyzeDisease() {

    if (selectedImage == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a leaf image."),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("AI Analysis"),

          content: const Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                "Disease : Leaf Blight",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              Text("Confidence : 94%"),

              SizedBox(height: 10),

              Text("Severity : Medium"),

              SizedBox(height: 10),

              Text(
                "Treatment:\nApply Copper Fungicide",
              ),

              SizedBox(height: 10),

              Text(
                "Prevention:\nAvoid excess watering and remove infected leaves.",
              ),

            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )

          ],
        );

      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F8F2),

      appBar: AppBar(
        title: const Text("Disease Detection"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              height: 250,
              width: double.infinity,

              decoration: BoxDecoration(

                color: Colors.grey.shade200,

                borderRadius:
                    BorderRadius.circular(20),

                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),

              ),

              child: selectedImage == null

                  ? const Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.green,
                        ),

                        SizedBox(height: 15),

                        Text(
                          "No Image Selected",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),

                      ],
                    )

                  : ClipRRect(

                      borderRadius:
                          BorderRadius.circular(20),

                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 30),

            Row(

              children: [

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },

                    icon: const Icon(Icons.camera_alt),

                    label: const Text("Camera"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),

                  ),
                ),

                const SizedBox(width: 15),

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },

                    icon: const Icon(Icons.photo),

                    label: const Text("Gallery"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),

                  ),
                ),

              ],
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed: analyzeDisease,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),

                child: const Text(
                  "Analyze Disease",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

              ),
            ),

            const SizedBox(height: 30),

            Card(

              elevation: 4,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: const ListTile(

                leading: Icon(
                  Icons.info,
                  color: Colors.green,
                ),

                title: Text("AI Disease Detection"),

                subtitle: Text(
                    "Upload a clear image of the crop leaf for accurate analysis."),

              ),
            ),

          ],
        ),
      ),
    );
  }
}