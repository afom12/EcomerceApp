import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SizeGuideWidget extends StatelessWidget {
  final String category;

  const SizeGuideWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Size Guide',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSizeTable(context),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Measurements are in inches. For best fit, measure yourself and compare with the size chart.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeTable(BuildContext context) {
    // Size guide data - can be customized per category
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
    final measurements = [
      ['Bust', '32', '34', '36', '38', '40', '42'],
      ['Waist', '24', '26', '28', '30', '32', '34'],
      ['Hip', '34', '36', '38', '40', '42', '44'],
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(AppColors.primaryLight),
        columns: [
          const DataColumn(label: Text('Size')),
          ...sizes.map((size) => DataColumn(label: Text(size))),
        ],
        rows: measurements.map((measurement) {
          return DataRow(
            cells: [
              DataCell(Text(measurement[0])),
              ...measurement.sublist(1).map((value) => DataCell(Text(value))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

