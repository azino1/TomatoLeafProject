import 'dart:typed_data';

class Plant {
  final String id;
  final DateTime time;
  bool isPending;
  final String PlantName;
  final String? plantImage;
  final Uint8List? localPlantImage;

  Plant({
    required this.id,
    required this.time,
    required this.PlantName,
    required this.plantImage,
    required this.localPlantImage,
    required this.isPending,
  });

  // factory Plant.fromServerData(){

  // }

  factory Plant.fromLocalMemory(Map<String, dynamic> data) {
    return Plant(
        id: data['id'],
        time: DateTime.parse(data['date']),
        PlantName: "Unknown Plant",
        plantImage: null,
        localPlantImage: data['image'],
        isPending: true);
  }
}
