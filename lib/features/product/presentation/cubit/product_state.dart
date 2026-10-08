import 'package:equatable/equatable.dart';
import 'package:medhat/features/product/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// Initial
class ProductInitial extends ProductState {
  const ProductInitial();
}

// First API request
class ProductLoading extends ProductState {
  const ProductLoading();
}

// Products loaded successfully
class ProductSuccess extends ProductState {
  final List<Product> products;
  final bool isLoadingMore;

  const ProductSuccess(this.products, {this.isLoadingMore = false});

  @override
  List<Object?> get props => [products, isLoadingMore];
}

// Refreshing existing products
class ProductRefreshing extends ProductState {
  final List<Product> products;

  const ProductRefreshing(this.products);

  @override
  List<Object?> get props => [products];
}

// Error
class ProductError extends ProductState {
  final String message;
  final List<Product> products;

  const ProductError(this.message, {this.products = const []});

  @override
  List<Object?> get props => [message, products];
}
