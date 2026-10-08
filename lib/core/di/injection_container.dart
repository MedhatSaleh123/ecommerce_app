import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:medhat/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:medhat/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:medhat/features/cart/domain/repositories/cart_repository.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_cubit.dart';

import 'package:medhat/features/product/data/datasource/product_remote_data_source.dart';
import 'package:medhat/features/product/data/repositories/product_repository_impl.dart';

import 'package:medhat/features/product/domain/repositories/product_repository.dart';
import 'package:medhat/features/product/domain/usecases/get_product_use_case.dart';
import 'package:medhat/features/product/domain/usecases/get_product_by_id_use_case.dart';

import 'package:medhat/features/product/presentation/cubit/product_cubit.dart';
import 'package:medhat/features/product/presentation/cubit/product_details_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhat/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:medhat/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:medhat/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:medhat/features/wishlist/presentation/cubit/wishlist_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Data Source
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  // Get Products
  sl.registerLazySingleton<GetProductUseCase>(
    () => GetProductUseCase(sl<ProductRepository>()),
  );

  // Product Cubit
  sl.registerFactory<ProductCubit>(() => ProductCubit(sl<GetProductUseCase>()));

  // Get Product By ID
  sl.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(sl<ProductRepository>()),
  );

  // Product Details Cubit
  sl.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(sl<GetProductByIdUseCase>()),
  );
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartLocalDataSource>()),
  );

  sl.registerFactory<CartCubit>(() => CartCubit(sl<CartRepository>()));
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(sl<WishlistLocalDataSource>()),
  );

  sl.registerFactory<WishlistCubit>(
    () => WishlistCubit(sl<WishlistRepository>()),
  );
}
