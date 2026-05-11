import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/food_model.dart';
import '../providers/app_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/food_card.dart';

class FoodListScreen extends StatefulWidget {
  final CategoryModel category;

  const FoodListScreen({
    super.key,
    required this.category,
  });

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final _searchController = TextEditingController();
  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodModel> _filterFoods(AppProvider provider) {
    final foods = provider.getFoodsByCategory(widget.category.id);
    final keyword = _keyword.trim().toLowerCase();
    if (keyword.isEmpty) {
      return foods;
    }
    return foods.where((food) => food.name.toLowerCase().contains(keyword)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: const [CartBadgeButton()],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final foods = _filterFoods(provider);
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.storefront, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nhà hàng KFC',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Khu 12', style: TextStyle(color: AppColors.muted)),
                        ],
                      ),
                    ),
                    Text(
                      'Thực đơn',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _keyword = value),
                decoration: InputDecoration(
                  hintText: 'Tìm trong danh mục...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _keyword.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _keyword = '');
                          },
                        ),
                ),
              ),
              const SizedBox(height: 18),
              if (foods.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'Không tìm thấy món phù hợp.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                )
              else
                ...foods.map(
                  (food) => FoodCard(
                    food: food,
                    onAdd: () {
                      provider.addToCart(food);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã thêm ${food.name} vào giỏ hàng')),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
