import 'package:medhat/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:medhat/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:medhat/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  Future<List<WishlistItem>> getWishlistItems() {
    return localDataSource.getWishlistItems();
  }

  @override
  Future<void> saveWishlistItems(List<WishlistItem> items) {
    return localDataSource.saveWishlistItems(items);
  }
}
