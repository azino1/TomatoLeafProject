import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';

import '../helpers/db.dart';
import '../models/plant.dart';

final plantsProvider = ChangeNotifierProvider((ref) {
  return PlantDataProvider();
});

class PlantDataProvider extends ChangeNotifier {
  List<Plant> _plantList = [];

  List<Plant> get plantList => _plantList;

  Future<void> fetchPlants() async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      //TODO: fetch analyst plants from server
    }
    final localPlants = await fetchLocalPlants();

    _plantList = [...localPlants];
    notifyListeners();
  }

  Future<List<Plant>> fetchLocalPlants() async {
    final dataList = await DBHelper.getData('plants_data');
    List<Plant> localPlants = [];
    dataList.forEach((element) {
      localPlants.add(Plant.fromLocalMemory(element));
    });
    return localPlants;
  }

  Future<void> fetchAnalytsPlants() async {}

  Future<void> savePlantLocally(Uint8List localPlantImage) async {
    final plantId = Uuid().v1();
    final newPlant = Plant(
        id: plantId,
        time: DateTime.now(),
        PlantName: "Unknown Plant",
        plantImage: null,
        localPlantImage: localPlantImage,
        isPending: true);
    //send plant to the local db
    await DBHelper.insert('plants_data', {
      'id': newPlant.id,
      'image': newPlant.localPlantImage,
      'date': newPlant.time.toIso8601String()
    });
    _plantList.add(newPlant);
    notifyListeners();
  }

  Future<void> syncLocalPlantsToServer() async {
    try {
      await Future.delayed(Duration(seconds: 10));
      //fetch local plants
      final localPlants = await fetchPlants();
      //TODO: send each of the plant to the ML model for analysing

      //TODO: clear the database
    } catch (e) {}
  }
}
