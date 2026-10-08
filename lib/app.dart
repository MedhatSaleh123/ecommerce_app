import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medhat/app/router/app_router.dart';
import 'package:medhat/core/di/injection_container.dart';

import 'package:medhat/features/product/presentation/cubit/product_cubit.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:medhat/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Product Cubit
        BlocProvider<ProductCubit>(
          create: (_) => sl<ProductCubit>()..getProducts(),
        ),

        // Cart Cubit
        BlocProvider<CartCubit>(create: (_) => sl<CartCubit>()..loadCart()),
        BlocProvider<WishlistCubit>(
          create: (_) => sl<WishlistCubit>()..loadWishlist(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
