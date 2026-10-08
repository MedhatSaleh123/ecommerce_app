import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medhat/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_state.dart';

import '../widgets/checkout_address_card.dart';
import '../widgets/checkout_payment_card.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/checkout_section_title.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  String _paymentMethod = 'Cash on Delivery';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final state = context.read<CartCubit>().state;

    if (state is! CartLoaded || state.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Order Placed'),
            ],
          ),
          content: const Text('Your order has been placed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                context.read<CartCubit>().clearCart();

                context.go('/products');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),

      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! CartLoaded || state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CheckoutSectionTitle(
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Address',
                  ),

                  const SizedBox(height: 12),

                  CheckoutAddressCard(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                  ),

                  const SizedBox(height: 24),

                  const CheckoutSectionTitle(
                    icon: Icons.payment_outlined,
                    title: 'Payment Method',
                  ),

                  const SizedBox(height: 12),

                  CheckoutPaymentCard(
                    selectedPayment: _paymentMethod,
                    onPaymentChanged: (value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  const CheckoutSectionTitle(
                    icon: Icons.receipt_long_outlined,
                    title: 'Order Summary',
                  ),

                  const SizedBox(height: 12),

                  CheckoutOrderSummary(cart: state),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
