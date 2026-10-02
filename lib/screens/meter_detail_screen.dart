import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/meter.dart';
import '../viewmodels/home_view_model.dart';

class MeterDetailScreen extends StatelessWidget {
  final Meter meter;
  final HomeViewModel viewModel;

  const MeterDetailScreen({
    super.key,
    required this.meter,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Информация о приборе',
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen =
              constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    isWideScreen ? 900 : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildMainCard(context),
                    const SizedBox(height: 20),
                    _buildCalculationCard(),
                    const SizedBox(height: 20),
                    _buildHistorySection(),
                    const SizedBox(height: 20),
                    _buildConsumptionChart(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainCard(
    BuildContext context,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
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
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    meter.resourceIcon,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
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
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meter.resourceName,
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
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
              '${meter.currentReading.toStringAsFixed(2)} '
                  '${meter.unit}',
            ),
            const SizedBox(height: 14),
            _buildInfoRow(
              'Показание прошлого месяца',
              '${meter.previousReading.toStringAsFixed(2)} '
                  '${meter.unit}',
            ),
            const SizedBox(height: 14),
            _buildInfoRow(
              'Последнее обновление',
              _formatDate(
                meter.lastReadingDate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationCard() {
    final consumption =
        viewModel.getConsumptionDifference(
      meter,
    );

    final tariff =
        viewModel.getTariff(
      meter.resourceType,
    );

    final totalCost =
        viewModel.getTotalCost(meter);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Расчёт за месяц',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildCalculationRow(
              icon: Icons
                  .trending_up,
              title:
                  'Расход за месяц',
              value:
                  '${consumption.toStringAsFixed(2)} '
                  '${meter.unit}',
            ),

            const SizedBox(height: 14),

            _buildCalculationRow(
              icon: Icons
                  .payments_outlined,
              title: 'Тариф',
              value:
                  '${tariff.toStringAsFixed(2)} '
                  '${viewModel.getTariffUnit(meter.resourceType)}',
            ),

            const Divider(height: 30),

            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 25,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Итоговая стоимость',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${totalCost.toStringAsFixed(2)} руб.',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color:
                  Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
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
              color:
                  Colors.grey.shade600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    final history =
        viewModel.getConsumptionHistory(
      meter,
    );

    final months =
        viewModel.getConsumptionMonths();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'История потребления',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (int i =
                    history.length - 1;
                i >= 0;
                i--)
              _buildHistoryItem(
                months[i],
                history[i],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    String month,
    double value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(month),
          ),
          Text(
            '${value.toStringAsFixed(2)} '
            '${meter.unit}',
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionChart(
    BuildContext context,
  ) {
    final values =
        viewModel.getConsumptionHistory(
      meter,
    );

    final months =
        viewModel.getConsumptionMonths();

    final maxValue =
        values.reduce(
              (a, b) =>
                  a > b ? a : b,
            ) *
            1.25;

    return Card(
      elevation: 0,
      child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'График потребления',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Изменение расхода '
              'за последние 6 месяцев',
              style: TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxValue,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine:
                        false,
                    horizontalInterval:
                        maxValue / 5,
                  ),
                  borderData:
                      FlBorderData(
                    show: false,
                  ),
                  titlesData:
                      FlTitlesData(
                    topTitles:
                        const AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles:
                        const AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: false,
                      ),
                    ),
                    bottomTitles:
                        AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        interval: 1,
                        getTitlesWidget:
                            (value, meta) {
                          final index =
                              value.toInt();

                          if (index < 0 ||
                              index >=
                                  months.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              months[index],
                              style:
                                  const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles:
                        AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval:
                            maxValue / 5,
                        getTitlesWidget:
                            (value, meta) {
                          return Text(
                            value
                                .toStringAsFixed(
                              0,
                            ),
                            style:
                                const TextStyle(
                              fontSize: 11,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData:
                      LineTouchData(
                    enabled: true,
                    touchTooltipData:
                        LineTouchTooltipData(
                      getTooltipItems:
                          (spots) {
                        return spots
                            .map(
                          (spot) {
                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(2)} '
                              '${meter.unit}',
                              const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            );
                          },
                        ).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0;
                            i < values.length;
                            i++)
                          FlSpot(
                            i.toDouble(),
                            values[i],
                          ),
                      ],
                      isCurved: true,
                      barWidth: 4,
                      dotData:
                          const FlDotData(
                        show: true,
                      ),
                      belowBarData:
                          BarAreaData(
                        show: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Единица измерения: '
                '${meter.unit}',
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}