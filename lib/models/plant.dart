import 'dart:typed_data';

enum Language {
  english,
  hausa,
}

class Plant {
  final String id;
  final DateTime time;
  bool isPending;
  final String plantName;
  final int healthStatus;
  final Uint8List? localPlantImage;
  final String virusName;

  Plant({
    required this.id,
    required this.time,
    required this.plantName,
    required this.healthStatus,
    required this.virusName,
    required this.localPlantImage,
    required this.isPending,
  });

  ///Collects data to build a plant object.
  factory Plant.fromLocalMemory(Map<String, dynamic> data) {
    return Plant(
        id: data['id'],
        time: DateTime.parse(data['date']),
        virusName: data['virus_name'],
        healthStatus: data['health_status'],
        plantName: data['health_status'] == 0 ? "Tomato Leaf" : "Unknow plant",
        localPlantImage: data['image'],
        isPending: data['analysis_status'] == 1 ? true : false);
  }
}
