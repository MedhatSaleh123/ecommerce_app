import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:medhat/features/product/data/models/product_model.dart';
import 'package:medhat/features/wishlist/domain/entities/wishlist_item.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItem>> getWishlistItems();

  Future<void> saveWishlistItems(List<WishlistItem> items);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final SharedPreferences preferences;

  static const String wishlistKey = 'wishlist_items';

  WishlistLocalDataSourceImpl(this.preferences);

  @override
  Future<List<WishlistItem>> getWishlistItems() async {
    final data = preferences.getString(wishlistKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(data);

      return jsonList.map((json) {
        return WishlistItem(
          product: ProductModel.fromJson(
            Map<String, dynamic>.from(json['product']),
          ),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveWishlistItems(List<WishlistItem> items) async {
    final jsonList = items.map((item) {
      return {'product': ProductModel.fromProduct(item.product).toJson()};
    }).toList();

    await preferences.setString(wishlistKey, jsonEncode(jsonList));
  }
}
