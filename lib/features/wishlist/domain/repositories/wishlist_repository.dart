import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlistItems();

  Future<void> saveWishlistItems(List<WishlistItem> items);
}
