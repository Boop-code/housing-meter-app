import 'package:flutter/material.dart';

import '../models/meter.dart';

class MeterDetailScreen extends StatelessWidget {
  final Meter meter;

  const MeterDetailScreen({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о приборе'),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? 900 : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainCard(context),

                    const SizedBox(height: 20),

                    _buildHistorySection(),

                    const SizedBox(height: 20),

                    _buildChartPlaceholder(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    meter.resourceIcon,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        meter.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        meter.resourceName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            _buildInfoRow(
              'Номер прибора',
              meter.serialNumber,
            ),

            const SizedBox(height: 14),

            _buildInfoRow(
              'Текущее показание',
              '${meter.currentReading.toStringAsFixed(2)} ${meter.unit}',
            ),

            const SizedBox(height: 14),

            _buildInfoRow(
              'Последнее обновление',
              _formatDate(meter.lastReadingDate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'История показаний',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _buildHistoryItem(
              '25.09.2026',
              meter.currentReading,
            ),

            _buildHistoryItem(
              '25.08.2026',
              meter.currentReading - 8.4,
            ),

            _buildHistoryItem(
              '25.07.2026',
              meter.currentReading - 17.1,
            ),

            _buildHistoryItem(
              '25.06.2026',
              meter.currentReading - 26.3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    String date,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 18,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(date),
          ),

          Text(
            '${value.toStringAsFixed(2)} ${meter.unit}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Потребление',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 50,
                    ),

                    SizedBox(height: 10),

                    Text(
                      'График потребления',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Будет реализован в следующих лабораторных работах',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}