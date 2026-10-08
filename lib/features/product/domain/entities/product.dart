class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String brand;
  final double rating;
  final int stock;
  final String image;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.rating,
    required this.stock,
    required this.image,
    required this.images,
  });
}
