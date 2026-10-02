enum ResourceType {
  water,
  gas,
  electricity,
}

class Meter {
  final int id;
  final String name;
  final String serialNumber;
  final ResourceType resourceType;
  final String unit;

  /// Текущее показание.
  final double currentReading;

  /// Показание за предыдущий месяц.
  final double previousReading;

  final DateTime lastReadingDate;

  const Meter({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.resourceType,
    required this.unit,
    required this.currentReading,
    required this.previousReading,
    required this.lastReadingDate,
  });

  String get resourceName {
    switch (resourceType) {
      case ResourceType.water:
        return 'Вода';
      case ResourceType.gas:
        return 'Газ';
      case ResourceType.electricity:
        return 'Электричество';
    }
  }

  String get resourceIcon {
    switch (resourceType) {
      case ResourceType.water:
        return '💧';
      case ResourceType.gas:
        return '🔥';
      case ResourceType.electricity:
        return '⚡';
    }
  }
}