import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.brand,
    required super.rating,
    required super.stock,
    required super.image,
    required super.images,
  });

  factory ProductModel.fromProduct(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      description: product.description,
      price: product.price,
      category: product.category,
      brand: product.brand,
      rating: product.rating,
      stock: product.stock,
      image: product.image,
      images: product.images,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagesJson = json['images'];

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      image: json['thumbnail'] ?? '',
      images: imagesJson is List
          ? imagesJson.map((e) => e.toString()).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'rating': rating,
      'stock': stock,
      'thumbnail': image,
      'images': images,
    };
  }
}
