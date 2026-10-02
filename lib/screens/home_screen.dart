import 'package:flutter/material.dart';

import '../viewmodels/home_view_model.dart';
import '../widgets/meter_card.dart';
import '../widgets/resource_filter.dart';
import 'meter_detail_screen.dart';
import 'mock_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = HomeViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();

    super.dispose();
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
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isWideScreen =
                  constraints.maxWidth >= 900;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        isWideScreen ? 1000 : double.infinity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        ResourceFilter(
                          selectedType:
                              viewModel.selectedType,
                          onChanged: (type) {
                            viewModel.setResourceFilter(
                              type,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: viewModel.meters.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  itemCount:
                                      viewModel.meters.length,
                                  itemBuilder:
                                      (context, index) {
                                    final meter =
                                        viewModel.meters[index];

                                    return MeterCard(
                                      meter: meter,
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                MeterDetailScreen(
                                              meter: meter,
                                              viewModel:
                                                  viewModel,
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
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MockScannerScreen(
                viewModel: viewModel,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.document_scanner_outlined,
        ),
        label: const Text('Сканировать'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
          'Выберите прибор, чтобы посмотреть '
          'показания, расход и стоимость',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Всего приборов: ${viewModel.totalMeters}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
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
}