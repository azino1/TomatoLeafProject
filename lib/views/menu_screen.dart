import 'dart:io';
import 'dart:typed_data';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';

class NewCaptureScreen extends StatefulWidget {
  static const routeName = "/new-captured";
  const NewCaptureScreen({super.key});

  @override
  State<NewCaptureScreen> createState() => _NewCaptureScreenState();
}

class _NewCaptureScreenState extends State<NewCaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  File? file;
  late Uint8List imageData;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Column(
        children: [
          customAppBar(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Previous Results',
                style: TextStyle(color: primaryColor, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return dataCard();
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: 12),
          ),
          const SizedBox(height: 20),
          Text('Click here to take a photo of the plant'),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: captureNewImage,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "New Capture",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget dataCard() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Leaf name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xffF4CE6B)),
                    child: Text('Pending'),
                  ),
                  const SizedBox(width: 25),
                  const Icon(Icons.arrow_forward_ios)
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          const Text('12:00 pm')
        ],
      ),
    );
  }

  Widget customAppBar() {
    final primaryColor = Theme.of(context).primaryColor;
    final sizeDevice = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      height: sizeDevice.height * 0.22,
      decoration: BoxDecoration(color: primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Welcome, Chief Hassen',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DropdownButton(
                value: "English",
                underline: null,
                dropdownColor: primaryColor,
                borderRadius: BorderRadius.circular(8),
                iconSize: 20,
                items: const [
                  DropdownMenuItem(
                      value: "English",
                      child: Text('English',
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                  DropdownMenuItem(
                      value: "Hause",
                      child: Text('Hausa',
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                ],
                onChanged: (val) {}),
          )
        ],
      ),
    );
  }

  void captureNewImage() async {
    await pickImage();
    showImageDailog();
  }

  void showImageDailog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        final primaryColor = Theme.of(context).primaryColor;
        return Dialog(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            padding:
                const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
            height: 400,
            width: double.infinity * 0.8,
            constraints: const BoxConstraints(minHeight: 400),
            child: LayoutBuilder(
              builder: (context, parentSize) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Complete New Capture",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(imageData),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 240,
                      child: Text(
                        "Please wait for few minutes after submission for the results",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: greyText),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: submitImageforAnalysis,
                      child: Container(
                        height: 45,
                        width: double.infinity * 0.9,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void submitImageforAnalysis() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      errorUpMessage(
          context, 'No Internet.. We will save your image locally', 'Alert');
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 360.0,
        maxHeight: 360.0,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.front,
      );

      file = File(pickedFile!.path);
      final Uint8List bytes = file!.readAsBytesSync();
      setState(() {
        _imageFile = pickedFile;
        imageData = bytes;
      });
    } catch (e) {
      print("error while picking image is $e");
      errorUpMessage(context, e.toString(), 'Error Alert');
    }
  }
}
