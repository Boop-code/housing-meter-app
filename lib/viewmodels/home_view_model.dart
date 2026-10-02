import 'package:flutter/foundation.dart';

import '../models/meter.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Meter> _meters = [
    Meter(
      id: 1,
      name: 'Счётчик холодной воды',
      serialNumber: 'CW-102458',
      resourceType: ResourceType.water,
      unit: 'м³',
      currentReading: 128.45,
      previousReading: 120.05,
      lastReadingDate: DateTime(2026, 9, 25),
    ),
    Meter(
      id: 2,
      name: 'Счётчик горячей воды',
      serialNumber: 'HW-783214',
      resourceType: ResourceType.water,
      unit: 'м³',
      currentReading: 86.20,
      previousReading: 79.90,
      lastReadingDate: DateTime(2026, 9, 25),
    ),
    Meter(
      id: 3,
      name: 'Газовый счётчик',
      serialNumber: 'GAS-458721',
      resourceType: ResourceType.gas,
      unit: 'м³',
      currentReading: 542.80,
      previousReading: 521.10,
      lastReadingDate: DateTime(2026, 9, 24),
    ),
    Meter(
      id: 4,
      name: 'Электросчётчик',
      serialNumber: 'EL-918273',
      resourceType: ResourceType.electricity,
      unit: 'кВт·ч',
      currentReading: 3842.60,
      previousReading: 3579.60,
      lastReadingDate: DateTime(2026, 9, 25),
    ),
  ];

  ResourceType? _selectedType;

  ResourceType? get selectedType => _selectedType;

  List<Meter> get meters {
    if (_selectedType == null) {
      return List.unmodifiable(_meters);
    }

    return List.unmodifiable(
      _meters.where(
        (meter) => meter.resourceType == _selectedType,
      ),
    );
  }

  int get totalMeters => _meters.length;

  int get waterMeters {
    return _meters
        .where(
          (meter) => meter.resourceType == ResourceType.water,
        )
        .length;
  }

  int get gasMeters {
    return _meters
        .where(
          (meter) => meter.resourceType == ResourceType.gas,
        )
        .length;
  }

  int get electricityMeters {
    return _meters
        .where(
          (meter) =>
              meter.resourceType == ResourceType.electricity,
        )
        .length;
  }

  void setResourceFilter(ResourceType? type) {
    _selectedType = type;
    notifyListeners();
  }

  void clearFilter() {
    _selectedType = null;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // Расчёт разницы с прошлым месяцем
  // ---------------------------------------------------------

  double getConsumptionDifference(Meter meter) {
    final difference =
        meter.currentReading - meter.previousReading;

    if (difference < 0) {
      return 0;
    }

    return difference;
  }

  // ---------------------------------------------------------
  // Тарифы
  // ---------------------------------------------------------

  double getTariff(ResourceType resourceType) {
    switch (resourceType) {
      case ResourceType.water:
        return 2.50;

      case ResourceType.gas:
        return 1.20;

      case ResourceType.electricity:
        return 0.25;
    }
  }

  String getTariffUnit(ResourceType resourceType) {
    switch (resourceType) {
      case ResourceType.water:
      case ResourceType.gas:
        return 'руб./м³';

      case ResourceType.electricity:
        return 'руб./кВт·ч';
    }
  }

  // ---------------------------------------------------------
  // Итоговая стоимость
  // ---------------------------------------------------------

  double getTotalCost(Meter meter) {
    final consumption =
        getConsumptionDifference(meter);

    final tariff =
        getTariff(meter.resourceType);

    return consumption * tariff;
  }

  // ---------------------------------------------------------
  // История потребления для графика
  // ---------------------------------------------------------

  List<double> getConsumptionHistory(Meter meter) {
    switch (meter.resourceType) {
      case ResourceType.water:
        return [
          7.8,
          8.2,
          8.7,
          8.1,
          9.0,
          getConsumptionDifference(meter),
        ];

      case ResourceType.gas:
        return [
          42.5,
          38.7,
          35.2,
          29.8,
          25.4,
          getConsumptionDifference(meter),
        ];

      case ResourceType.electricity:
        return [
          215.0,
          228.0,
          242.0,
          235.0,
          251.0,
          getConsumptionDifference(meter),
        ];
    }
  }

  List<String> getConsumptionMonths() {
    return [
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
    ];
  }

  // ---------------------------------------------------------
  // Добавление нового счётчика
  // ---------------------------------------------------------

  void addMeter({
    required ResourceType resourceType,
    required double reading,
  }) {
    final int newId = _meters.isEmpty
        ? 1
        : _meters
                .map((meter) => meter.id)
                .reduce(
                  (a, b) => a > b ? a : b,
                ) +
            1;

    final String serialNumber =
        'MOCK-$newId';

    final String name;

    switch (resourceType) {
      case ResourceType.water:
        name = 'Новый счётчик воды';
        break;

      case ResourceType.gas:
        name = 'Новый газовый счётчик';
        break;

      case ResourceType.electricity:
        name = 'Новый электросчётчик';
        break;
    }

    final String unit;

    switch (resourceType) {
      case ResourceType.water:
      case ResourceType.gas:
        unit = 'м³';
        break;

      case ResourceType.electricity:
        unit = 'кВт·ч';
        break;
    }

    _meters.add(
      Meter(
        id: newId,
        name: name,
        serialNumber: serialNumber,
        resourceType: resourceType,
        unit: unit,
        currentReading: reading,
        previousReading: reading,
        lastReadingDate: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}