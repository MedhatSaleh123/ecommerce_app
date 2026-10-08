import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medhat/features/cart/domain/entities/cart_item.dart';
import 'package:medhat/features/cart/domain/repositories/cart_repository.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit(this.repository) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());

    try {
      final items = await repository.getCartItems();

      emit(CartLoaded(items));
    } catch (e) {
      emit(const CartError('Failed to load cart'));
    }
  }

  Future<void> addToCart(CartItem newItem) async {
    if (newItem.product.stock <= 0) {
      return;
    }

    final items = _currentItems();

    final index = items.indexWhere(
      (item) => item.product.id == newItem.product.id,
    );

    if (index != -1) {
      final existingItem = items[index];

      final newQuantity = existingItem.quantity + newItem.quantity;

      final finalQuantity = newQuantity > existingItem.product.stock
          ? existingItem.product.stock
          : newQuantity;

      items[index] = existingItem.copyWith(quantity: finalQuantity);
    } else {
      final quantity = newItem.quantity > newItem.product.stock
          ? newItem.product.stock
          : newItem.quantity;

      items.add(newItem.copyWith(quantity: quantity));
    }

    await _save(items);
  }

  Future<void> increaseQuantity(int productId) async {
    final items = _currentItems();

    final index = items.indexWhere((item) => item.product.id == productId);

    if (index == -1) return;

    final item = items[index];

    if (item.quantity >= item.product.stock) {
      return;
    }

    items[index] = item.copyWith(quantity: item.quantity + 1);

    await _save(items);
  }

  Future<void> decreaseQuantity(int productId) async {
    final items = _currentItems();

    final index = items.indexWhere((item) => item.product.id == productId);

    if (index == -1) return;

    final item = items[index];

    if (item.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    }

    await _save(items);
  }

  Future<void> removeFromCart(int productId) async {
    final items = _currentItems();

    items.removeWhere((item) => item.product.id == productId);

    await _save(items);
  }

  Future<void> clearCart() async {
    await _save([]);
  }

  List<CartItem> _currentItems() {
    if (state is CartLoaded) {
      return List<CartItem>.from((state as CartLoaded).items);
    }

    return [];
  }

  Future<void> _save(List<CartItem> items) async {
    await repository.saveCartItems(items);

    emit(CartLoaded(List<CartItem>.from(items)));
  }
}
