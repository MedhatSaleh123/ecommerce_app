import 'package:dio/dio.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  });

  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    final response = await dio.get(
      'https://dummyjson.com/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    final data = response.data as Map<String, dynamic>;

    final products = data['products'] as List;

    return products
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await dio.get('https://dummyjson.com/products/$id');

    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }
}
