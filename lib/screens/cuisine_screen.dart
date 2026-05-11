import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_model.dart';
import '../providers/app_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/category_card.dart';
import '../widgets/food_card.dart';
import 'food_list_screen.dart';

class CuisineScreen extends StatefulWidget {
  const CuisineScreen({super.key});

  @override
  State<CuisineScreen> createState() => _CuisineScreenState();
}

class _CuisineScreenState extends State<CuisineScreen> {
  final _searchController = TextEditingController();
  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodModel> _searchFoods(AppProvider provider) {
    final keyword = _keyword.trim().toLowerCase();
    if (keyword.isEmpty) {
      return [];
    }
    return provider.foods.where((food) => food.name.toLowerCase().contains(keyword)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Ứng dụng đặt món'),
        actions: const [CartBadgeButton()],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final user = provider.userLogin;
          final results = _searchFoods(provider);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào, ${user?.fullName ?? user?.email ?? 'Khách hàng'}',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFFD86E52)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.24),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đặt món ngon mỗi ngày',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Chọn món yêu thích và thêm vào giỏ hàng',
                                    style: TextStyle(color: Colors.white70, height: 1.35),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.ramen_dining, color: Colors.white, size: 54),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _keyword = value),
                        decoration: InputDecoration(
                          hintText: 'Tìm món ăn...',
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
                      if (_keyword.trim().isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const Text(
                          'Kết quả tìm kiếm',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (results.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Không tìm thấy món phù hợp.',
                              style: TextStyle(color: AppColors.muted),
                            ),
                          )
                        else
                          ...results.map(
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
                      const SizedBox(height: 10),
                      const Text(
                        'Phân loại món ăn',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Chọn nền văn hóa ẩm thực yêu thích',
                        style: TextStyle(color: AppColors.muted, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = provider.categories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodListScreen(category: category),
                            ),
                          );
                        },
                      );
                    },
                    childCount: provider.categories.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.86,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
