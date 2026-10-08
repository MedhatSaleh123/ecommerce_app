import 'package:medhat/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:medhat/features/cart/domain/entities/cart_item.dart';
import 'package:medhat/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<List<CartItem>> getCartItems() {
    return localDataSource.getCartItems();
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) {
    return localDataSource.saveCartItems(items);
  }
}
