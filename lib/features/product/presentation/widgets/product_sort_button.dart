import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medhat/features/product/presentation/cubit/product_cubit.dart';

class ProductSortButton extends StatelessWidget {
  const ProductSortButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'low') {
          cubit.sortByPrice(ascending: true);
        } else {
          cubit.sortByPrice(ascending: false);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'low', child: Text('Price: Low to High')),
        PopupMenuItem(value: 'high', child: Text('Price: High to Low')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.sort), SizedBox(width: 6), Text('Sort')],
        ),
      ),
    );
  }
}
