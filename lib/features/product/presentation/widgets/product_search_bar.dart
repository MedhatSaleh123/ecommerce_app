import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_cubit.dart';

class ProductSearchBar extends StatefulWidget {
  final EdgeInsetsGeometry padding;

  const ProductSearchBar({super.key, this.padding = const EdgeInsets.all(16)});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<ProductCubit>().searchProducts(value);

    setState(() {});
  }

  void _clear() {
    _controller.clear();

    context.read<ProductCubit>().searchProducts('');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),

          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(onPressed: _clear, icon: const Icon(Icons.clear))
              : null,

          filled: true,
          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
