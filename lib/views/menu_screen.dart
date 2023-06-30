import 'dart:io';
import 'dart:typed_data';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tomato_leave_virus_mobile/data.dart';
import 'package:tomato_leave_virus_mobile/helpers/api_call.dart';
import 'package:tomato_leave_virus_mobile/helpers/firebase_service.dart';
import 'package:tomato_leave_virus_mobile/providers/language_provider.dart';
import 'package:tomato_leave_virus_mobile/providers/user_provider.dart';

import '../constant.dart';
import '../models/plant.dart';
import '../providers/plant_data_provider.dart';
import 'virus_detail_page.dart';
import 'widgets/datacard_widget.dart';

class NewCaptureScreen extends ConsumerStatefulWidget {
  static const routeName = "/new-captured";
  const NewCaptureScreen({super.key});

  @override
  ConsumerState<NewCaptureScreen> createState() => _NewCaptureScreenState();
}

class _NewCaptureScreenState extends ConsumerState<NewCaptureScreen> {
  /// Initialize the image picker
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  File? file;

  bool isScanningLocal = false;

  Language _selectedLanguage = Language.english;

  //would later hold the imageData after being capture by a user
  late Uint8List imageData;

  /// Would later hold the future call needed by the futurebuilder.
  ///
  /// [fetchFuture] would later be transfer to it. It is to able refreshing
  late Future futureHolder;

  ///Holds the state of the submitting button.
  ///
  ///True if it is pressed and false if it is not.
  ///Initially set to false.
  bool isSubmitingImage = false;

  ///Activates the plants fetch listener.
  ///
  ///This functions is expected to load before the screen build,
  /// as it is called inside [initState]
  Future<bool> fetchFuture() async {
    try {
      await ref.read(plantsProvider).fetchVirusDataFromFirebase();
    } catch (e) {
      await ref.read(plantsProvider).fetchLocalVirusData();
    }
    try {
      await ref.read(plantsProvider).fetchPlants();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  //will run before the screen builds
  @override
  void initState() {
    //Here, 'fetchFuture' has been transfer to 'futureHolder'
    futureHolder = fetchFuture();
    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Holds the primaryColor Theme of this app.
    final primaryColor = Theme.of(context).primaryColor;

    ///Holds the device size that the app is being run on
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          customAppBar(),
          const SizedBox(height: 20),
          Consumer(builder: (context, ref, child) {
            final isHause = ref.watch(isHausa);
            return Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isHause ? "Sakamako na baya" : 'Previous Results',
                  style: TextStyle(color: primaryColor, fontSize: 18),
                ),
              ),
            );
          }),
          FutureBuilder(
              future: futureHolder,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: primaryColor,
                      ),
                    ),
                  );
                }
                if (snapshot.data == true) {
                  return Consumer(builder: (context, ref, _) {
                    /// [plants] holds the list of plants gotten from the plant listener.
                    ///
                    /// It could be empty if there is no plant found.
                    final plants = ref.watch(plantsProvider).plantList;
                    final isHause = ref.watch(isHausa);

                    return plants.isEmpty
                        ? SizedBox(
                            height: deviceSize.height * 0.52,
                            child: Center(
                                child: Text(isHause
                                    ? "Har yanzu ba a kama Shuka ba"
                                    : "No Plant capture yet.. ")),
                          )
                        : Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return DataCard(plant: plants[index]);
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: plants.length),
                          );
                  });
                }

                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }),
          const SizedBox(height: 20),
          Consumer(builder: (context, ref, child) {
            final isHause = ref.watch(isHausa);
            return Column(
              children: [
                Text(isHause
                    ? "Danna nan don ɗaukar hoto na shuka"
                    : 'Click here to take a photo of the plant'),
                const SizedBox(
                  height: 10,
                ),
                PopupMenuButton(
                  child: Center(
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
                          const Icon(
                            Icons.photo_camera_outlined,
                            size: 24,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            isHause ? "Sabon kamawa" : "New Capture",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onSelected: (result) {
                    captureNewImage(result == 2);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.browse_gallery_outlined,
                            size: 20.0,
                            // color: appCardText,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            isHause ? "Daga gallery" : 'From Gallery',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 20.0,
                            // color: appCardText,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            isHause ? "Daga Kamara" : "From Camera",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// The appBar widget of the capturing screen
  Widget customAppBar() {
    final primaryColor = Theme.of(context).primaryColor;
    final sizeDevice = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      final user = ref.read(userProvider).mainUser;
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        height: sizeDevice.height * 0.22,
        decoration: BoxDecoration(color: primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Consumer(builder: (context, ref, child) {
              final isHause = ref.watch(isHausa);
              return RichText(
                text: TextSpan(children: [
                  TextSpan(text: !isHause ? 'Welcome, ' : "Barka da zuwa, "),
                  TextSpan(
                      text: user != null
                          ? "${user.firstName} ${user.lastName}"
                          : 'Anonymous User')
                ], style: const TextStyle(color: Colors.white, fontSize: 18)),
              );
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: DropdownButton(
                  value: _selectedLanguage,
                  underline: null,
                  dropdownColor: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  iconSize: 20,
                  items: const [
                    DropdownMenuItem(
                        value: Language.english,
                        child: Text('English',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12))),
                    DropdownMenuItem(
                        value: Language.hausa,
                        child: Text('Hausa',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedLanguage = val;
                      });
                      ref.read(isHausa.notifier).changeLanguage(val);
                    }
                  }),
            )
          ],
        ),
      );
    });
  }

  ///causes the camera to open for image capturing, thereafter activates the dialog box that displays the image picked.
  void captureNewImage(bool fromCamera) async {
    setState(() {
      _imageFile = null;
    });
    await pickImage(fromCamera);
    if (_imageFile != null) {
      showImageDailog();
    }
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
            width: double.infinity * 0.8,
            constraints: const BoxConstraints(minHeight: 400),
            child: LayoutBuilder(
              builder: (context, parentSize) {
                return Consumer(builder: (context, ref, child) {
                  final isHause = ref.watch(isHausa);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: isHause
                              ? const Text(
                                  "Cikakkun Sabbin Ɗauka",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : const Text(
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
                      SizedBox(
                        width: 240,
                        child: isHause
                            ? const Text(
                                "Da fatan za a jira 'yan mintuna kaɗan bayan ƙaddamar da sakamakon",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: greyText),
                              )
                            : const Text(
                                "Please wait for few minutes after submission for the results",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: greyText),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return isSubmitingImage
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 20,
                                  child: LinearProgressIndicator(
                                    backgroundColor: primaryColor,
                                  ))
                              : InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isSubmitingImage = true;
                                    });
                                    await submitImageforAnalysis();
                                    setState(() {
                                      isSubmitingImage = false;
                                    });

                                    if (!mounted) return;
                                    // closes the dailog.
                                    context.pop();
                                  },
                                  child: Container(
                                    height: 45,
                                    width: double.infinity * 0.9,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Center(
                                      child: Text(
                                        isHause ? "Sallama" : "Submit",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }

  ///submit the image picked to the ML model.
  ///
  ///
  ///if the there is no internet, it activates the listener that saves the image locally
  Future<void> submitImageforAnalysis() async {
    bool result = await InternetConnectionChecker().hasConnection;
    final isHause = ref.read(isHausa);
    if (!result) {
      if (mounted) {
        isHause
            ? errorUpMessage(context,
                'Babu Intanet. Za mu adana hotonku a gida', 'Fadakarwa')
            : errorUpMessage(context,
                'No Internet.. We will save your image locally', 'Alert');
        await Future.delayed(const Duration(seconds: 2));
      }

      await ref.read(plantsProvider).saveUnScannedPlantLocally(imageData);
    } else {
      if (_imageFile != null) {
        try {
          final scanningResult =
              await ApiServices.predictPlantDisease(_imageFile!.path);

          final int healthStatus =
              scanningResult.toLowerCase().contains("healthy")
                  ? 0
                  : scanningResult.toLowerCase().contains("tomato")
                      ? 1
                      : 2;
          print("the health status is $healthStatus");
          await ref
              .read(plantsProvider)
              .saveScannedPlant(scanningResult, healthStatus, imageData);
        } catch (e) {
          print(e);
          errorUpMessage(context, e.toString(), 'Error');
        }
      }
    }
  }

  ///Does the actuall capturing of the image.
  Future<void> pickImage(bool fromCamera) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
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
