import 'package:flutter/material.dart';

class ProductDetailsSkeleton extends StatefulWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  State<ProductDetailsSkeleton> createState() => _ProductDetailsSkeletonState();
}

class _ProductDetailsSkeletonState extends State<ProductDetailsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                final slide = _controller.value * 2 - 1;

                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Color(0xFFE5E5EA),
                    Color(0xFFF7F7F9),
                    Color(0xFFE5E5EA),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  transform: _SlidingGradientTransform(slide),
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: child,
            );
          },
          child: const _SkeletonContent(),
        ),
      ),
    );
  }
}

class _SkeletonContent extends StatelessWidget {
  const _SkeletonContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              const _SkeletonBox(height: 360, borderRadius: 0),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + stock
                    Row(
                      children: const [
                        _SkeletonBox(width: 90, height: 28, borderRadius: 20),
                        SizedBox(width: 10),
                        _SkeletonBox(width: 75, height: 28, borderRadius: 20),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Title
                    const _SkeletonBox(
                      width: double.infinity,
                      height: 28,
                      borderRadius: 8,
                    ),

                    const SizedBox(height: 10),

                    const _SkeletonBox(width: 220, height: 28, borderRadius: 8),

                    const SizedBox(height: 18),

                    // Rating
                    Row(
                      children: const [
                        _SkeletonBox(width: 100, height: 22, borderRadius: 8),
                        SizedBox(width: 12),
                        _SkeletonBox(width: 70, height: 22, borderRadius: 8),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Price
                    const _SkeletonBox(width: 130, height: 34, borderRadius: 8),

                    const SizedBox(height: 28),

                    // Description title
                    const _SkeletonBox(width: 130, height: 24, borderRadius: 8),

                    const SizedBox(height: 12),

                    // Description
                    const _SkeletonBox(
                      width: double.infinity,
                      height: 18,
                      borderRadius: 6,
                    ),

                    const SizedBox(height: 8),

                    const _SkeletonBox(
                      width: double.infinity,
                      height: 18,
                      borderRadius: 6,
                    ),

                    const SizedBox(height: 8),

                    const _SkeletonBox(width: 250, height: 18, borderRadius: 6),

                    const SizedBox(height: 28),

                    // Product information
                    const _SkeletonBox(width: 180, height: 24, borderRadius: 8),

                    const SizedBox(height: 16),

                    const _InfoSkeletonRow(),
                    const SizedBox(height: 12),
                    const _InfoSkeletonRow(),
                    const SizedBox(height: 12),
                    const _InfoSkeletonRow(),

                    const SizedBox(height: 28),

                    // Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _SkeletonBox(width: 100, height: 24, borderRadius: 8),
                        _SkeletonBox(width: 130, height: 45, borderRadius: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Back button
        Positioned(top: 16, left: 16, child: _CircleSkeleton(size: 45)),

        // Favorite button
        Positioned(top: 16, right: 16, child: _CircleSkeleton(size: 45)),

        // Bottom Add To Cart
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: const [
                _SkeletonBox(width: 90, height: 40, borderRadius: 10),
                SizedBox(width: 12),
                Expanded(child: _SkeletonBox(height: 52, borderRadius: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoSkeletonRow extends StatelessWidget {
  const _InfoSkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _SkeletonBox(width: 100, height: 18, borderRadius: 6),
        Spacer(),
        _SkeletonBox(width: 120, height: 18, borderRadius: 6),
      ],
    );
  }
}

class _CircleSkeleton extends StatelessWidget {
  final double size;

  const _CircleSkeleton({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE5E5EA),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
