import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medhat/features/cart/domain/entities/cart_item.dart';
import 'package:medhat/features/cart/presentation/cubit/cart_cubit.dart';

import 'package:medhat/features/product/domain/entities/product.dart';
import 'package:medhat/features/product/presentation/cubit/product_details_cubit.dart';
import 'package:medhat/features/product/presentation/cubit/product_details_state.dart';
import 'package:medhat/features/product/presentation/widgets/product_details_skeleton.dart';
import 'package:medhat/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:medhat/features/wishlist/presentation/cubit/wishlist_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();

  int _currentImageIndex = 0;
  int _quantity = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      body: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const ProductDetailsSkeleton();
          }

          if (state is ProductDetailsError) {
            return _buildErrorState(context);
          }

          if (state is ProductDetailsSuccess) {
            return _buildContent(context, state.product);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final images = product.images.isNotEmpty ? product.images : [product.image];

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildImageSection(images)),

            SliverToBoxAdapter(child: _buildProductInfo(product)),

            SliverToBoxAdapter(child: _buildDescription(product)),

            SliverToBoxAdapter(child: _buildSpecifications(product)),

            SliverToBoxAdapter(child: _buildQuantity(product)),

            const SliverToBoxAdapter(child: SizedBox(height: 130)),
          ],
        ),

        _buildTopButtons(context, product),

        _buildBottomCartBar(context, product),
      ],
    );
  }

  // ----------------------------------------------------------
  // TOP BUTTONS
  // ----------------------------------------------------------

  Widget _buildTopButtons(BuildContext context, Product product) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () {
                context.pop();
              },
            ),

            BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                final isFavorite = context.read<WishlistCubit>().isFavorite(
                  product.id,
                );

                return IconButton(
                  onPressed: () {
                    context.read<WishlistCubit>().toggleWishlist(product);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: iconColor, size: 21),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // IMAGE SECTION
  // ----------------------------------------------------------

  Widget _buildImageSection(List<String> images) {
    return SizedBox(
      height: 440,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF0F0F4), Color(0xFFF8F8FA)],
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(35, 80, 35, 30),
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorWidget: (context, url, error) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          if (images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final selected = index == _currentImageIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selected ? 26 : 8,
                    height: 7,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRODUCT INFO
  // ----------------------------------------------------------

  Widget _buildProductInfo(Product product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _categoryBadge(product.category),
              const Spacer(),
              _stockBadge(product.stock),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            product.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 12),

          _buildRating(product),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'USD',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _stockBadge(int stock) {
    final inStock = stock > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: inStock
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: inStock ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            inStock ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
              color: inStock ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating(Product product) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (product.rating >= index + 1) {
            return const Icon(Icons.star, color: Colors.amber, size: 21);
          }

          if (product.rating > index) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 21);
          }

          return const Icon(Icons.star_border, color: Colors.amber, size: 21);
        }),
        const SizedBox(width: 8),
        Text(
          product.rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        const Text(
          'Product Rating',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // DESCRIPTION
  // ----------------------------------------------------------

  Widget _buildDescription(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 10),

          Text(
            product.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SPECIFICATIONS
  // ----------------------------------------------------------

  Widget _buildSpecifications(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 5, 22, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Information',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 18),

          _infoItem(
            Icons.business_outlined,
            'Brand',
            product.brand.isEmpty ? 'Unknown' : product.brand,
          ),

          _infoItem(Icons.category_outlined, 'Category', product.category),

          _infoItem(
            Icons.inventory_2_outlined,
            'Available',
            '${product.stock} items',
          ),

          _infoItem(Icons.tag_outlined, 'Product ID', product.id.toString()),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.deepPurple),
          ),

          const SizedBox(width: 12),

          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // QUANTITY
  // ----------------------------------------------------------

  Widget _buildQuantity(Product product) {
    final canIncrease = _quantity < product.stock;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quantity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _quantityButton(
                  icon: Icons.remove,
                  enabled: _quantity > 1,
                  onTap: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                ),

                SizedBox(
                  width: 42,
                  child: Text(
                    '$_quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _quantityButton(
                  icon: Icons.add,
                  enabled: canIncrease,
                  onTap: () {
                    if (canIncrease) {
                      setState(() {
                        _quantity++;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 19),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM CART BAR
  // ----------------------------------------------------------

  Widget _buildBottomCartBar(BuildContext context, Product product) {
    final total = product.price * _quantity;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 18),

              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: product.stock <= 0
                        ? null
                        : () {
                            context.read<CartCubit>().addToCart(
                              CartItem(product: product, quantity: _quantity),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    '${product.title} added to cart ($_quantity)',
                                  ),
                                ),
                              );
                          },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ERROR
  // ----------------------------------------------------------

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_outlined,
                size: 42,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'We could not load this product.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductDetailsCubit>().getProduct(
                  widget.productId,
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
