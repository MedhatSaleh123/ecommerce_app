import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medhat/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_state.dart';

import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is! CartLoaded || state.items.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: 'Clear cart',
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () {
                  _showClearDialog(context);
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return _buildError(context, state.message);
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const EmptyCart();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];

                      return CartItemCard(
                        item: item,
                        onIncrease: () {
                          context.read<CartCubit>().increaseQuantity(
                            item.product.id,
                          );
                        },
                        onDecrease: () {
                          context.read<CartCubit>().decreaseQuantity(
                            item.product.id,
                          );
                        },
                        onDelete: () {
                          context.read<CartCubit>().removeFromCart(
                            item.product.id,
                          );
                        },
                      );
                    },
                  ),
                ),

                CartSummary(
                  totalItems: state.totalItems,
                  subtotal: state.totalPrice,

                  onCheckout: () {
                    context.push('/checkout');
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CartCubit>().loadCart();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text('Are you sure you want to remove all products?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<CartCubit>().clearCart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
