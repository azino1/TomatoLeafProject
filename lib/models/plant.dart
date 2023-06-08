import 'dart:typed_data';

enum Language {
  english,
  hausa,
}

class Plant {
  final String id;
  final DateTime time;
  bool isPending;
  String plantName;
  int healthStatus;
  final Uint8List? localPlantImage;
  String virusName;

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
  ///
  /// analysisStatus 0f 0=> pending, 1=>done
  /// healthstatus of 0=>Healthy, 1=>Diseased, others=>Unknown
  factory Plant.fromLocalMemory(Map<String, dynamic> data) {
    return Plant(
        id: data['id'],
        time: DateTime.parse(data['date']),
        virusName: data['virus_name'],
        healthStatus: data['health_status'],
        plantName: data['health_status'] == 0
            ? "Healthy Leaf / Unknown plant"
            : data['analysis_status'] == 1
                ? "Tomato Leaf with Virus"
                : "Unknown plant",
        localPlantImage: data['image'],
        isPending: data['analysis_status'] == 0 ? true : false);
  }
}
