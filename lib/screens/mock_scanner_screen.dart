import 'package:flutter/material.dart';

import '../models/meter.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/mock_scanner_view_model.dart';

class MockScannerScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const MockScannerScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<MockScannerScreen> createState() =>
      _MockScannerScreenState();
}

class _MockScannerScreenState
    extends State<MockScannerScreen> {
  late final MockScannerViewModel scannerViewModel;

  @override
  void initState() {
    super.initState();

    scannerViewModel =
        MockScannerViewModel();
  }

  @override
  void dispose() {
    scannerViewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Сканирование счётчика',
        ),
      ),
      body: ListenableBuilder(
        listenable: scannerViewModel,
        builder: (context, _) {
          return Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 700,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDescription(),
                    const SizedBox(height: 20),
                    _buildCameraPreview(),
                    const SizedBox(height: 20),
                    _buildResourceSelector(),
                    const SizedBox(height: 20),
                    _buildResult(),
                    const SizedBox(height: 20),
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 40,
              color:
                  Theme.of(context)
                      .colorScheme
                      .primary,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mock-сканирование',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Реальная камера не используется. '
                    'Экран имитирует фотографирование '
                    'табло и автоматическое распознавание цифр.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    final bool isScanning =
        scannerViewModel.state ==
            ScannerState.scanning;

    return Card(
      clipBehavior:
          Clip.antiAlias,
      elevation: 0,
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.speed_outlined,
                  size: 90,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 25),
                _buildMeterDisplay(),
              ],
            ),

            if (isScanning)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Распознавание показания...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Text(
                  'MOCK CAMERA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 30,
              right: 30,
              top: 35,
              bottom: 35,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white54,
                    width: 2,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeterDisplay() {
    String value;

    switch (
        scannerViewModel.resourceType) {
      case ResourceType.water:
        value = '128.45';
        break;

      case ResourceType.gas:
        value = '542.80';
        break;

      case ResourceType.electricity:
        value = '3842.60';
        break;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade700,
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: 5,
        ),
      ),
    );
  }

  Widget _buildResourceSelector() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Тип ресурса',
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<
                ResourceType>(
              initialValue:
                  scannerViewModel.resourceType,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value:
                      ResourceType.water,
                  child: Text(
                    '💧 Вода',
                  ),
                ),
                DropdownMenuItem(
                  value:
                      ResourceType.gas,
                  child: Text(
                    '🔥 Газ',
                  ),
                ),
                DropdownMenuItem(
                  value:
                      ResourceType.electricity,
                  child: Text(
                    '⚡ Электричество',
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  scannerViewModel
                      .setResourceType(
                    value,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (scannerViewModel.state !=
        ScannerState.recognized) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 50,
            ),
            const SizedBox(height: 12),
            const Text(
              'Показание распознано',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              scannerViewModel
                  .recognizedText,
              style: const TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getUnit(
                scannerViewModel.resourceType,
              ),
              style: TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final bool isScanning =
        scannerViewModel.state ==
            ScannerState.scanning;

    final bool isRecognized =
        scannerViewModel.state ==
            ScannerState.recognized;

    if (isRecognized) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                final value =
                    scannerViewModel
                        .recognizedValue;

                if (value == null) {
                  return;
                }

                widget.viewModel.addMeter(
                  resourceType:
                      scannerViewModel
                          .resourceType,
                  reading: value,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Счётчик добавлен',
                    ),
                  ),
                );

                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.add,
              ),
              label: const Text(
                'Добавить показание',
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              scannerViewModel.reset();
            },
            child: const Text(
              'Сканировать повторно',
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isScanning
            ? null
            : () {
                scannerViewModel
                    .scanMeter();
              },
        icon: const Icon(
          Icons.document_scanner,
        ),
        label: Text(
          isScanning
              ? 'Распознавание...'
              : 'Распознать показание',
        ),
      ),
    );
  }

  String _getUnit(
    ResourceType type,
  ) {
    switch (type) {
      case ResourceType.water:
      case ResourceType.gas:
        return 'м³';

      case ResourceType.electricity:
        return 'кВт·ч';
    }
  }
}