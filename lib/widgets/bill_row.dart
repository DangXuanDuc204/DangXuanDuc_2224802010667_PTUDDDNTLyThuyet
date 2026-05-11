import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/formatters.dart';

class BillRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool isDiscount;

  const BillRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isTotal
        ? AppColors.primary
        : isDiscount
            ? AppColors.success
            : AppColors.text;
    final prefix = isDiscount && value > 0 ? '- ' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isTotal ? AppColors.text : AppColors.muted,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$prefix${formatCurrency(value)}',
            style: TextStyle(
              color: color,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
