import 'package:medhat/features/product/domain/entities/product.dart';
import 'package:medhat/features/product/domain/repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository productsRepository;

  GetProductUseCase(this.productsRepository);

  Future<List<Product>> call({required int limit, required int skip}) {
    return productsRepository.getProducts(limit: limit, skip: skip);
  }
}
