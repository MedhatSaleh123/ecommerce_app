import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductCategoryFilter extends StatelessWidget {
  const ProductCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final cubit = context.read<ProductCubit>();

        final categories = cubit.categories;

        return SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 8);
            },
            itemBuilder: (context, index) {
              final category = categories[index];

              final isSelected = cubit.selectedCategory == category;

              return ChoiceChip(
                label: Text(_formatCategory(category)),
                selected: isSelected,
                onSelected: (_) {
                  cubit.filterByCategory(category);
                },
              );
            },
          ),
        );
      },
    );
  }

  String _formatCategory(String category) {
    if (category == 'all') {
      return 'All';
    }

    return category
        .split('-')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }
}
