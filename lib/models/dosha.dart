import 'package:flutter/material.dart';

enum PrakritiType {
  vata,
  pitta,
  kapha,
  vataPitta,
  pittaKapha,
  vataKapha,
  tridoshic;

  String get displayName {
    switch (this) {
      case PrakritiType.vata:
        return 'Vata';
      case PrakritiType.pitta:
        return 'Pitta';
      case PrakritiType.kapha:
        return 'Kapha';
      case PrakritiType.vataPitta:
        return 'Vata-Pitta';
      case PrakritiType.pittaKapha:
        return 'Pitta-Kapha';
      case PrakritiType.vataKapha:
        return 'Vata-Kapha';
      case PrakritiType.tridoshic:
        return 'Tridoshic';
    }
  }

  String get description {
    switch (this) {
      case PrakritiType.vata:
        return 'Air and space elements dominate. You are creative, energetic, and quick-thinking, but may experience anxiety and irregular patterns.';
      case PrakritiType.pitta:
        return 'Fire and water elements dominate. You are focused, determined, and organized, but may experience anger and intensity.';
      case PrakritiType.kapha:
        return 'Earth and water elements dominate. You are calm, stable, and nurturing, but may experience sluggishness and attachment.';
      case PrakritiType.vataPitta:
        return 'A balanced combination of air/space and fire/water elements. You combine creativity with focus, but may experience both restlessness and intensity.';
      case PrakritiType.pittaKapha:
        return 'A balanced combination of fire/water and earth/water elements. You combine determination with stability, but may experience both intensity and sluggishness.';
      case PrakritiType.vataKapha:
        return 'A balanced combination of air/space and earth/water elements. You combine creativity with stability, but may experience both restlessness and sluggishness.';
      case PrakritiType.tridoshic:
        return 'All three doshas are equally balanced. You have the potential for great health and adaptability, but require careful attention to maintain balance.';
    }
  }
}

enum DoshaType {
  vata,
  pitta,
  kapha;

  String get displayName {
    switch (this) {
      case DoshaType.vata:
        return 'Vata';
      case DoshaType.pitta:
        return 'Pitta';
      case DoshaType.kapha:
        return 'Kapha';
    }
  }
}

class Dosha {
  final DoshaType type;
  final String name;
  final String description;
  final Color primaryColor;
  final String iconPath;
  final List<String> characteristics;

  const Dosha({
    required this.type,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.iconPath,
    required this.characteristics,
  });

  static const Dosha vata = Dosha(
    type: DoshaType.vata,
    name: 'Vata',
    description: 'The energy of movement, governed by air and space elements.',
    primaryColor: Color(0xFF9C27B0), // Purple
    iconPath: 'assets/icons/vata.png',
    characteristics: [
      'Creative and energetic',
      'Quick thinking and adaptable',
      'Irregular patterns',
      'Prone to anxiety and restlessness',
      'Dry skin and hair',
      'Light sleep',
      'Variable appetite',
    ],
  );

  static const Dosha pitta = Dosha(
    type: DoshaType.pitta,
    name: 'Pitta',
    description:
        'The energy of transformation, governed by fire and water elements.',
    primaryColor: Color(0xFFFF5722), // Deep Orange
    iconPath: 'assets/icons/pitta.png',
    characteristics: [
      'Focused and determined',
      'Strong leadership qualities',
      'Organized and efficient',
      'Prone to anger and criticism',
      'Oily or sensitive skin',
      'Moderate sleep',
      'Strong appetite',
    ],
  );

  static const Dosha kapha = Dosha(
    type: DoshaType.kapha,
    name: 'Kapha',
    description:
        'The energy of structure, governed by earth and water elements.',
    primaryColor: Color(0xFF4CAF50), // Green
    iconPath: 'assets/icons/kapha.png',
    characteristics: [
      'Calm and stable',
      'Nurturing and compassionate',
      'Strong endurance',
      'Prone to sluggishness and attachment',
      'Thick, oily skin',
      'Deep, long sleep',
      'Slow but steady appetite',
    ],
  );

  static List<Dosha> get all => [vata, pitta, kapha];

  static Dosha getByType(DoshaType type) {
    switch (type) {
      case DoshaType.vata:
        return vata;
      case DoshaType.pitta:
        return pitta;
      case DoshaType.kapha:
        return kapha;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'name': name,
      'description': description,
      'primaryColor': primaryColor.toARGB32(),
      'iconPath': iconPath,
      'characteristics': characteristics,
    };
  }

  factory Dosha.fromJson(Map<String, dynamic> json) {
    return Dosha(
      type: DoshaType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'] as String,
      description: json['description'] as String,
      primaryColor: Color(json['primaryColor'] as int),
      iconPath: json['iconPath'] as String,
      characteristics: List<String>.from(json['characteristics'] as List),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dosha &&
        other.type == type &&
        other.name == name &&
        other.description == description &&
        other.primaryColor == primaryColor &&
        other.iconPath == iconPath &&
        other.characteristics.length == characteristics.length &&
        other.characteristics.every((char) => characteristics.contains(char));
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      name,
      description,
      primaryColor,
      iconPath,
      characteristics,
    );
  }
}
