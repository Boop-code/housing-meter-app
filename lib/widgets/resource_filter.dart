import 'package:flutter/material.dart';

import '../models/meter.dart';

class ResourceFilter extends StatelessWidget {
  final ResourceType? selectedType;
  final ValueChanged<ResourceType?> onChanged;

  const ResourceFilter({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilter(
            context,
            title: 'Все',
            type: null,
          ),
          const SizedBox(width: 8),
          _buildFilter(
            context,
            title: '💧 Вода',
            type: ResourceType.water,
          ),
          const SizedBox(width: 8),
          _buildFilter(
            context,
            title: '🔥 Газ',
            type: ResourceType.gas,
          ),
          const SizedBox(width: 8),
          _buildFilter(
            context,
            title: '⚡ Электричество',
            type: ResourceType.electricity,
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(
    BuildContext context, {
    required String title,
    required ResourceType? type,
  }) {
    final bool isSelected = selectedType == type;

    return FilterChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (_) {
        onChanged(type);
      },
    );
  }
}