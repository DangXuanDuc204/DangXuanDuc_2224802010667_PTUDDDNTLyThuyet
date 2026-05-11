import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/app_network_image.dart';
import '../widgets/bill_row.dart';
import 'payment_success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.cart.isEmpty) {
            return const Center(
              child: Text(
                'Giỏ hàng của bạn đang trống',
                style: TextStyle(color: AppColors.muted, fontSize: 18),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    ...provider.cart.map(
                      (item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.07),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AppNetworkImage(
                                imageUrl: item.food.image,
                                width: 70,
                                height: 70,
                                fallbackIcon: Icons.fastfood,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.food.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatCurrency(item.food.price),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Giảm',
                              onPressed: () => provider.decreaseQty(item.food.id),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              tooltip: 'Tăng',
                              onPressed: () => provider.increaseQty(item.food.id),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            IconButton(
                              tooltip: 'Xóa',
                              onPressed: () {
                                provider.removeFromCart(item.food.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã xóa khỏi giỏ hàng')),
                                );
                              },
                              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.receipt_long, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'Hóa đơn thanh toán',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          BillRow(label: 'Tổng tiền món ăn', value: provider.getItemsTotal()),
                          BillRow(
                            label: 'Giảm giá',
                            value: provider.getOfferDiscount(),
                            isDiscount: true,
                          ),
                          BillRow(label: 'Thuế (8%)', value: provider.getTaxes()),
                          BillRow(label: 'Phí giao hàng', value: provider.getDeliveryCharges()),
                          const Divider(height: 26),
                          BillRow(
                            label: 'Tổng thanh toán',
                            value: provider.getTotalPay(),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatCurrency(provider.getTotalPay()),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                      onPressed: () {
                        final paidTotal = provider.getTotalPay();
                        provider.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thanh toán hoàn tất')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentSuccessScreen(totalPaid: paidTotal),
                          ),
                        );
                      },
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text('Tiến hành thanh toán'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
