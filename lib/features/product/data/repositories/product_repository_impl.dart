import 'package:medhat/features/product/data/datasource/product_remote_data_source.dart';
import 'package:medhat/features/product/domain/entities/product.dart';
import 'package:medhat/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  const ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts({
    required int limit,
    required int skip,
  }) async {
    final models = await remoteDataSource.getProducts(limit: limit, skip: skip);

    return models.map<Product>((model) => model).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final model = await remoteDataSource.getProductById(id);
    return model;
  }
}
