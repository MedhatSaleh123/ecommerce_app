import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medhat/features/product/domain/entities/product.dart';
import 'package:medhat/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:medhat/features/wishlist/domain/repositories/wishlist_repository.dart';

import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository repository;

  WishlistCubit(this.repository) : super(WishlistInitial());

  Future<void> loadWishlist() async {
    emit(WishlistLoading());

    try {
      final items = await repository.getWishlistItems();

      emit(WishlistLoaded(items));
    } catch (e) {
      emit(const WishlistError('Failed to load wishlist'));
    }
  }

  Future<void> toggleWishlist(Product product) async {
    final items = _currentItems();

    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      items.removeAt(index);
    } else {
      items.add(WishlistItem(product: product));
    }

    await _save(items);
  }

  bool isFavorite(int productId) {
    if (state is! WishlistLoaded) {
      return false;
    }

    final items = (state as WishlistLoaded).items;

    return items.any((item) => item.product.id == productId);
  }

  Future<void> removeFromWishlist(int productId) async {
    final items = _currentItems();

    items.removeWhere((item) => item.product.id == productId);

    await _save(items);
  }

  Future<void> clearWishlist() async {
    await _save([]);
  }

  List<WishlistItem> _currentItems() {
    if (state is WishlistLoaded) {
      return List<WishlistItem>.from((state as WishlistLoaded).items);
    }

    return [];
  }

  Future<void> _save(List<WishlistItem> items) async {
    await repository.saveWishlistItems(items);

    emit(WishlistLoaded(List<WishlistItem>.from(items)));
  }
}
