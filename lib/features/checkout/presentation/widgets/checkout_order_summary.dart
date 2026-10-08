import 'package:flutter/material.dart';

import 'package:medhat/features/cart/presentation/cubit/cart_state.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final CartLoaded cart;

  const CheckoutOrderSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    const shipping = 5.0;

    final subtotal = cart.totalPrice;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SummaryRow(title: 'Items', value: '${cart.totalItems}'),

          const SizedBox(height: 14),

          SummaryRow(
            title: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 14),

          const SummaryRow(title: 'Shipping', value: '\$5.00'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),

          SummaryRow(
            title: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const SummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? Colors.deepPurple : Colors.black,
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
