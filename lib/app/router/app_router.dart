import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medhat/core/di/injection_container.dart';
import 'package:medhat/features/checkout/presentation/pages/checkout_page.dart';

import 'package:medhat/features/product/presentation/cubit/product_details_cubit.dart';
import 'package:medhat/features/product/presentation/home_page.dart';
import 'package:medhat/features/product/presentation/pages/product_details_page.dart';

import 'package:medhat/features/cart/presentation/pages/cart_page.dart';

import 'package:medhat/features/wishlist/presentation/pages/wishlist_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/products',

    routes: [
      // =========================
      // Products
      // =========================
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) {
          return const HomePage();
        },
      ),

      // =========================
      // Product Details
      // =========================
      GoRoute(
        path: '/products/:id',
        name: 'productDetails',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          return BlocProvider<ProductDetailsCubit>(
            create: (_) => sl<ProductDetailsCubit>()..getProduct(id),
            child: ProductDetailsPage(productId: id),
          );
        },
      ),

      // =========================
      // Cart
      // =========================
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) {
          return const CartPage();
        },
      ),

      // =========================
      // Wishlist
      // =========================
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) {
          return const WishlistPage();
        },
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) {
          return const CheckoutPage();
        },
      ),
    ],
  );
}
