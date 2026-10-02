import 'package:flutter/material.dart';

import '../models/meter.dart';
import '../widgets/meter_card.dart';
import '../widgets/resource_filter.dart';
import 'meter_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ResourceType? selectedType;

  final List<Meter> meters = [
    Meter(
      id: 1,
      name: 'Счётчик холодной воды',
      serialNumber: 'CW-102458',
      resourceType: ResourceType.water,
      unit: 'м³',
      currentReading: 128.45,
      lastReadingDate: DateTime(2026, 9, 25),
    ),

    Meter(
      id: 2,
      name: 'Счётчик горячей воды',
      serialNumber: 'HW-783214',
      resourceType: ResourceType.water,
      unit: 'м³',
      currentReading: 86.20,
      lastReadingDate: DateTime(2026, 9, 25),
    ),

    Meter(
      id: 3,
      name: 'Газовый счётчик',
      serialNumber: 'GAS-458721',
      resourceType: ResourceType.gas,
      unit: 'м³',
      currentReading: 542.80,
      lastReadingDate: DateTime(2026, 9, 24),
    ),

    Meter(
      id: 4,
      name: 'Электросчётчик',
      serialNumber: 'EL-918273',
      resourceType: ResourceType.electricity,
      unit: 'кВт·ч',
      currentReading: 3842.60,
      lastReadingDate: DateTime(2026, 9, 25),
    ),
  ];

  List<Meter> get filteredMeters {
    if (selectedType == null) {
      return meters;
    }

    return meters
        .where((meter) => meter.resourceType == selectedType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Учёт показаний ЖКХ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? 1000 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 24),

                    ResourceFilter(
                      selectedType: selectedType,
                      onChanged: (type) {
                        setState(() {
                          selectedType = type;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: filteredMeters.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: filteredMeters.length,
                              itemBuilder: (context, index) {
                                final meter = filteredMeters[index];

                                return MeterCard(
                                  meter: meter,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MeterDetailScreen(
                                          meter: meter,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMockScanDialog(context);
        },
        icon: const Icon(Icons.document_scanner_outlined),
        label: const Text('Сканировать'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Мои приборы учёта',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Выберите прибор, чтобы посмотреть историю показаний',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 16),

          Text(
            'Приборов этого типа нет',
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showMockScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Сканирование счётчика'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 70,
              ),

              SizedBox(height: 16),

              Text(
                'В рамках лабораторной работы '
                'используется mock-механизм камеры.',
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              Text(
                'Распознавание реальной камеры '
                'реализовываться не будет.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}