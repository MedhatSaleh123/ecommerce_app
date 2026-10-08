import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_state.dart';
import 'package:medhat/features/product/presentation/widgets/product_card.dart';
import 'package:medhat/features/product/presentation/widgets/product_search_bar.dart';
import 'package:medhat/features/product/presentation/widgets/product_skeleton.dart';
import 'package:medhat/features/product/presentation/widgets/product_sort_button.dart';

import 'package:medhat/features/product/presentation/cubit/product_cubit.dart';
import 'package:medhat/features/product/presentation/cubit/product_state.dart';

import 'widgets/product_category_filter.dart';
import 'package:go_router/go_router.dart';

import 'package:medhat/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:medhat/features/wishlist/presentation/cubit/wishlist_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  // =========================
  // INFINITE SCROLL
  // =========================

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              final count = state is WishlistLoaded ? state.totalItems : 0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/wishlist');
                    },
                    icon: const Icon(Icons.favorite_border, size: 28),
                  ),

                  if (count > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Cart
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final count = state is CartLoaded ? state.totalItems : 0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/cart');
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                  ),

                  if (count > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: ProductSearchBar(padding: EdgeInsets.zero)),

                const SizedBox(width: 8),

                ProductSortButton(),
              ],
            ),
          ),

          const ProductCategoryFilter(),
          Expanded(
            child: BlocConsumer<ProductCubit, ProductState>(
              listener: (context, state) {
                if (state is ProductError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },

              builder: (context, state) {
                if (state is ProductLoading) {
                  return const ProductSkeletonList();
                }

                if (state is ProductRefreshing) {
                  return _buildProductList(
                    products: state.products,
                    isLoadingMore: false,
                  );
                }

                if (state is ProductSuccess) {
                  if (state.products.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildProductList(
                    products: state.products,
                    isLoadingMore: state.isLoadingMore,
                  );
                }

                if (state is ProductError) {
                  if (state.products.isNotEmpty) {
                    return _buildProductList(
                      products: state.products,
                      isLoadingMore: false,
                    );
                  }

                  return _buildErrorState(message: state.message);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PRODUCT LIST
  // =====================================================

  Widget _buildProductList({
    required List products,
    required bool isLoadingMore,
  }) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<ProductCubit>().getProducts(isRefresh: true);
      },

      child: ListView.builder(
        controller: _scrollController,

        itemCount: products.length + (isLoadingMore ? 1 : 0),

        itemBuilder: (context, index) {
          // =========================
          // LOADING MORE INDICATOR
          // =========================

          if (index == products.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // =========================
          // PRODUCT
          // =========================

          final product = products[index];

          return ProductCard(product: product);
        },
      ),
    );
  }
  // =====================================================
  // EMPTY STATE
  // =====================================================

  Widget _buildEmptyState() {
    final cubit = context.read<ProductCubit>();

    String message;

    if (cubit.searchQuery.isNotEmpty) {
      message = 'No products found for "${cubit.searchQuery}"';
    } else if (cubit.selectedCategory != 'all') {
      message = 'No products found in this category';
    } else {
      message = 'No products found';
    }

    return Center(child: Text(message, textAlign: TextAlign.center));
  }
  // =====================================================
  // ERROR STATE
  // =====================================================

  Widget _buildErrorState({required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.error_outline, size: 70),

            const SizedBox(height: 20),

            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductCubit>().getProducts();
              },

              icon: const Icon(Icons.refresh),

              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
