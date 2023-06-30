class Virus {
  final String name;
  final String about;
  final String management;
  final List transmission;
  final String language;

  Virus({
    required this.name,
    required this.about,
    required this.language,
    required this.management,
    required this.transmission,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'about': about,
      'language': language,
      'management': management,
      'transmission': transmission.join('-'),
    };
  }

  factory Virus.fromMap(Map<String, dynamic> map, String language) {
    return Virus(
      name: map['name'],
      about: map['about'],
      language: language,
      management: map['management'],
      transmission: map['transmission'].split('-'),
    );
  }
}
