import 'package:equatable/equatable.dart';

import 'package:medhat/features/product/domain/entities/product.dart';

class WishlistItem extends Equatable {
  final Product product;

  const WishlistItem({required this.product});

  @override
  List<Object?> get props => [product];
}
