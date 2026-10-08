import 'package:flutter/material.dart';

class CheckoutPaymentCard extends StatelessWidget {
  final String selectedPayment;
  final ValueChanged<String> onPaymentChanged;

  const CheckoutPaymentCard({
    super.key,
    required this.selectedPayment,
    required this.onPaymentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          RadioListTile<String>(
            value: 'Cash on Delivery',
            groupValue: selectedPayment,
            activeColor: Colors.deepPurple,
            onChanged: (value) {
              if (value != null) {
                onPaymentChanged(value);
              }
            },
            title: const Text(
              'Cash on Delivery',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Pay when your order arrives'),
            secondary: const Icon(Icons.local_atm_outlined),
          ),

          const Divider(height: 1),

          RadioListTile<String>(
            value: 'Credit Card',
            groupValue: selectedPayment,
            activeColor: Colors.deepPurple,
            onChanged: (value) {
              if (value != null) {
                onPaymentChanged(value);
              }
            },
            title: const Text(
              'Credit Card',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Pay securely with your card'),
            secondary: const Icon(Icons.credit_card_outlined),
          ),
        ],
      ),
    );
  }
}
