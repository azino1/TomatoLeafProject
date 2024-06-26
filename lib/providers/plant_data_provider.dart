import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tomato_leave_virus_mobile/helpers/firebase_service.dart';
import 'package:tomato_leave_virus_mobile/models/virus_model.dart';
import 'package:uuid/uuid.dart';

import '../helpers/db.dart';
import '../models/plant.dart';

final plantsProvider = ChangeNotifierProvider((ref) {
  return PlantDataProvider();
});

class PlantDataProvider extends ChangeNotifier {
  /// An array that holds all the plants captured by a user. it being hold as a private variable
  List<Plant> _plantList = [];

  List<Virus> _virusList = [];

  /// A plants getter that get Array of item from _plantList
  List<Plant> get plantList => _plantList.reversed.toList();

  List<Virus> get virusList => _virusList;

  /// Listens to user request to fetch plants data both locally and from server.
  ///
  /// It first check for internect connectivity to remote data then fetches locally saved data.
  /// After fetching this data as an Array, it is assign a copy to [_plantList] while also notifying all listeners
  Future<void> fetchPlants() async {
    bool result = await InternetConnectionChecker().hasConnection;
    final localPlants = await fetchLocalPlants();

    _plantList = [...localPlants];
    notifyListeners();
  }

  /// calls [DBHelper.getData]to fetch plant data stored locally.
  ///
  /// Return an Array of [Plants]
  Future<List<Plant>> fetchLocalPlants() async {
    final dataList = await DBHelper.getData('plants_data');
    List<Plant> localPlants = [];
    dataList.forEach((element) {
      localPlants.add(Plant.fromLocalMemory(element));
    });
    return localPlants;
  }

  Future<void> updateAnalysedLocalPlant(
      String plantId, int healthStatus, String virusName) async {
    final index = _plantList.indexWhere((element) => element.id == plantId);

    if (index != -1) {
      _plantList[index].healthStatus = healthStatus;
      _plantList[index].virusName = virusName;
      _plantList[index].isPending = false;
      _plantList[index].plantName = healthStatus == 0
          ? "Healthy Leaf / Unknown plant"
          : healthStatus == 1
              ? "Tomato Leaf with Virus"
              : "Unknown plant";
    }

    await DBHelper.updatePlantData(
        'plants_data',
        {
          "virus_name": virusName,
          "analysis_status": 1,
          "health_status": healthStatus,
        },
        plantId);

    notifyListeners();
  }

  ///save scanned plant data to the local db
  ///
  ///analysisStatus 0f 0=> pending, 1=>done
  ///healthstatus of 0=>Healthy, 1=>Diseased, others=>Unknown
  Future<void> saveScannedPlant(
      String virusName, int healthStatus, Uint8List localPlantImage) async {
    //Generates a unique with Uuid package
    final plantId = const Uuid().v1();
    final newPlant = Plant(
        id: plantId,
        healthStatus: healthStatus,
        time: DateTime.now(),
        virusName: virusName,
        plantName: healthStatus == 0
            ? "Healthy Leaf / Unknown plant"
            : healthStatus == 1
                ? virusName.replaceAll("_", " ")
                : "Unknown Plant",
        localPlantImage: localPlantImage,
        isPending: false);

    await DBHelper.insert('plants_data', {
      'id': newPlant.id,
      'image': newPlant.localPlantImage,
      'date': newPlant.time.toIso8601String(),
      "virus_name": virusName,
      "analysis_status": 1,
      "health_status": healthStatus,
    });

    _plantList.add(newPlant);
    notifyListeners();
  }

  ///Listeners to user requst to save plant data locally when there is no internet connectivity.
  ///And we can connect to ML server.
  Future<void> saveUnScannedPlantLocally(Uint8List localPlantImage) async {
    /// Generates a unique with Uuid package
    final plantId = const Uuid().v1();
    final newPlant = Plant(
        id: plantId,
        healthStatus: 2,
        virusName: "Unkown Plant & Virus",
        time: DateTime.now(),
        plantName: "Unknown Plant",
        localPlantImage: localPlantImage,
        isPending: true);

    ///save unscanned plant data to the local db
    ///
    ///analysisStatus 0f 0=> pending, 1=>done
    ///healthstatus of 0=>Healthy, 1=>Diseased, others=>Unknown
    await DBHelper.insert('plants_data', {
      'id': newPlant.id,
      'image': newPlant.localPlantImage,
      'date': newPlant.time.toIso8601String(),
      "virus_name": "Unknown Virus",
      "analysis_status": 0,
      "health_status": 2,
    });
    _plantList.add(newPlant);
    notifyListeners();
  }

  /// Sync all locally saved data to the remote ML server for analysis.
  Future<void> syncLocalPlantsForAnalysis() async {
    try {
      await Future.delayed(Duration(seconds: 10));

      ///fetch local plants
      final localPlants = await fetchPlants();
      //TODO: send each of the plant to the ML model for analysing

      //TODO: clear the database
    } catch (e) {}
  }

  ///This function fetches all the virus data from firebase and save it locally
  Future<void> fetchVirusDataFromFirebase() async {
    try {
      final virusDataList = await FirebaseServices().getVirusesData();
      print("virus list $virusDataList");

      virusDataList.forEach((element) {
        element.forEach((key, value) {
          _virusList.add(Virus.fromMap(value, key));
        });
      });
      final virustList = await DBHelper.getVirusItems();
      if (virustList.isNotEmpty) {
        await DBHelper.deleteAllVirusData('virus_data');
      }

      _virusList.forEach((element) async {
        await DBHelper.insertVirusItem(element);
      });
      print("virus list $_virusList");
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchLocalVirusData() async {
    try {
      final virusList = await DBHelper.getVirusItems();
      _virusList = virusList;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePlant(String plantId) async {
    try {
      final index = _plantList.indexWhere((element) => element.id == plantId);

      if (index != -1) {
        await DBHelper.deleteData('plants_data', plantId);
        _plantList.removeAt(index);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
