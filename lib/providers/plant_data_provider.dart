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
  /// An array that holds all the plants captured by a user. it being hold as a private variable
  List<Plant> _plantList = [];

  /// A plants getter that get Array of item from _plantList
  List<Plant> get plantList => _plantList;

  /// Listens to user request to fetch plants data both locally and from server.
  ///
  /// It first check for internect connectivity to remote data then fetches locally saved data.
  /// After fetching this data as an Array, it is assign a copy to [_plantList] while also notifying all listeners
  Future<void> fetchPlants() async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      //TODO: fetch analyst plants from server
    }
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

  Future<void> fetchAnalytsPlants() async {}

  ///Listeners to user requst to save plant data locally when there is no internet connectivity.
  Future<void> savePlantLocally(Uint8List localPlantImage) async {
    /// Generates a unique with Uuid package
    final plantId = Uuid().v1();
    final newPlant = Plant(
        id: plantId,
        time: DateTime.now(),
        PlantName: "Unknown Plant",
        plantImage: null,
        localPlantImage: localPlantImage,
        isPending: true);

    ///save plant data to the local db
    await DBHelper.insert('plants_data', {
      'id': newPlant.id,
      'image': newPlant.localPlantImage,
      'date': newPlant.time.toIso8601String()
    });
    _plantList.add(newPlant);
    notifyListeners();
  }

  /// Sync all locally saved data to the remote server.
  Future<void> syncLocalPlantsToServer() async {
    try {
      await Future.delayed(Duration(seconds: 10));

      ///fetch local plants
      final localPlants = await fetchPlants();
      //TODO: send each of the plant to the ML model for analysing

      //TODO: clear the database
    } catch (e) {}
  }
}
