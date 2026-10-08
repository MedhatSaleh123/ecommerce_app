import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medhat/features/product/domain/usecases/get_product_use_case.dart';

import 'package:medhat/core/error/failure.dart';
import '../../domain/entities/product.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductUseCase getProductsUseCase;

  ProductCubit(this.getProductsUseCase) : super(const ProductInitial());

  // =========================
  // PRODUCTS
  // =========================

  // All products loaded from API
  List<Product> allProducts = [];

  // Products currently displayed
  // after search / filter / sort
  List<Product> displayedProducts = [];

  // =========================
  // SEARCH / FILTER / SORT
  // =========================

  String searchQuery = '';

  String selectedCategory = 'all';

  // true  = Low → High
  // false = High → Low
  bool sortAscending = true;

  // =========================
  // PAGINATION
  // =========================

  static const int pageSize = 10;

  int currentSkip = 0;

  bool hasMore = true;
  List<String> get categories {
    final categories = allProducts
        .map((product) => product.category.toLowerCase())
        .toSet()
        .toList();

    categories.sort();

    return ['all', ...categories];
  }

  // =========================
  // GET PRODUCTS
  // =========================

  Future<void> getProducts({bool isRefresh = false}) async {
    // --------------------------------
    // Loading State
    // --------------------------------

    if (isRefresh && allProducts.isNotEmpty) {
      // Keep old products visible
      emit(ProductRefreshing(displayedProducts));
    } else {
      // First request
      emit(const ProductLoading());
    }

    // --------------------------------
    // Reset Pagination
    // --------------------------------

    currentSkip = 0;
    hasMore = true;

    try {
      // --------------------------------
      // API Request
      // --------------------------------

      final products = await getProductsUseCase(
        limit: pageSize,
        skip: currentSkip,
      );

      // --------------------------------
      // Replace Old Data
      // --------------------------------

      allProducts = products;

      // --------------------------------
      // Check Pagination
      // --------------------------------

      if (products.length < pageSize) {
        hasMore = false;
      }

      // --------------------------------
      // Apply Search / Filter / Sort
      // --------------------------------

      applyFilters(emitState: false);

      // --------------------------------
      // Success
      // --------------------------------

      emit(ProductSuccess(displayedProducts));
    } on Failure catch (failure) {
      // Known application failure

      emit(ProductError(failure.message, products: displayedProducts));
    } catch (e) {
      // Unknown error

      emit(ProductError('Something went wrong', products: displayedProducts));
    }
  }

  // =========================
  // SEARCH
  // =========================

  void searchProducts(String query) {
    print('SEARCH: $query');
    print('PRODUCTS: ${allProducts.length}');
    searchQuery = query.trim().toLowerCase();

    applyFilters();
  }

  // =========================
  // FILTER
  // =========================

  void filterByCategory(String category) {
    selectedCategory = category.toLowerCase();

    applyFilters();
  }

  // =========================
  // SORT
  // =========================

  void sortByPrice({bool ascending = true}) {
    sortAscending = ascending;

    applyFilters();
  }

  // =========================
  // APPLY FILTERS
  // =========================

  void applyFilters({bool emitState = true, bool isLoadingMore = false}) {
    List<Product> filteredProducts = List<Product>.from(allProducts);

    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final title = product.title.toLowerCase();
        final category = product.category.toLowerCase();

        return title.contains(searchQuery) || category.contains(searchQuery);
      }).toList();
    }

    if (selectedCategory != 'all') {
      filteredProducts = filteredProducts.where((product) {
        return product.category.toLowerCase() == selectedCategory;
      }).toList();
    }

    filteredProducts.sort((a, b) {
      if (sortAscending) {
        return a.price.compareTo(b.price);
      }

      return b.price.compareTo(a.price);
    });

    displayedProducts = filteredProducts;

    if (emitState) {
      emit(ProductSuccess(displayedProducts, isLoadingMore: isLoadingMore));
    }
  }
  // =========================
  // LOAD MORE
  // =========================

  Future<void> loadMoreProducts() async {
    // --------------------------------
    // Prevent Duplicate Requests
    // --------------------------------

    if (state is ProductSuccess && (state as ProductSuccess).isLoadingMore) {
      return;
    }

    if (!hasMore) {
      return;
    }

    // --------------------------------
    // Next Page
    // --------------------------------

    final nextSkip = currentSkip + pageSize;

    // --------------------------------
    // Show Bottom Loading
    // --------------------------------

    emit(ProductSuccess(displayedProducts, isLoadingMore: true));

    try {
      // --------------------------------
      // API Request
      // --------------------------------

      final products = await getProductsUseCase(
        limit: pageSize,
        skip: nextSkip,
      );

      // --------------------------------
      // Update Pagination
      // --------------------------------

      currentSkip = nextSkip;

      if (products.length < pageSize) {
        hasMore = false;
      }

      // --------------------------------
      // Add New Products
      // --------------------------------

      allProducts.addAll(products);

      // --------------------------------
      // Reapply Search / Filter / Sort
      // --------------------------------

      applyFilters(emitState: false);

      // --------------------------------
      // Success
      // --------------------------------

      emit(ProductSuccess(displayedProducts, isLoadingMore: false));
    } on Failure catch (failure) {
      // Keep existing products

      emit(ProductError(failure.message, products: displayedProducts));
    } catch (e) {
      // Keep existing products

      emit(ProductError('Something went wrong', products: displayedProducts));
    }
  }
}
