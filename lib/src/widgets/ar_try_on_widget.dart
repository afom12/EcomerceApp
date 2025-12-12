import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ARTryOnWidget extends StatelessWidget {
  final String productImage;

  const ARTryOnWidget({super.key, required this.productImage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Virtual Try-On',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AR Try-On Coming Soon',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'This feature will allow you to virtually try on items using your device camera.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('AR Try-On feature coming soon!'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

