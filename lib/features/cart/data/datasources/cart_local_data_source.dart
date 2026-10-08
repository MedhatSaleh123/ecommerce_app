import 'dart:convert';
import 'package:medhat/features/cart/domain/entities/cart_item.dart';
import 'package:medhat/features/product/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();

  Future<void> saveCartItems(List<CartItem> items);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences preferences;

  static const String cartKey = 'cart_items';

  CartLocalDataSourceImpl(this.preferences);

  @override
  Future<List<CartItem>> getCartItems() async {
    final data = preferences.getString(cartKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(data);

      return jsonList.map((json) {
        return CartItem(
          product: ProductModel.fromJson(
            Map<String, dynamic>.from(json['product']),
          ),
          quantity: json['quantity'] as int,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    final jsonList = items.map((item) {
      return {
        'product': ProductModel.fromProduct(item.product).toJson(),
        'quantity': item.quantity,
      };
    }).toList();

    await preferences.setString(cartKey, jsonEncode(jsonList));
  }
}
