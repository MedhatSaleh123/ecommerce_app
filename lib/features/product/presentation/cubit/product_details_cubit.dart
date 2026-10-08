import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_product_by_id_use_case.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailsCubit(this.getProductByIdUseCase)
    : super(ProductDetailsInitial());

  Future<void> getProduct(int id) async {
    emit(ProductDetailsLoading());

    try {
      final product = await getProductByIdUseCase(id);

      emit(ProductDetailsSuccess(product));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}
