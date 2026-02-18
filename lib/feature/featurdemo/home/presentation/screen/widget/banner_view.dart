import 'package:flutter/material.dart';
import 'package:mainproject/core/widgets/fixed_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class BannerView extends StatefulWidget {
  final List<String> bannerImages;

  const BannerView({
    super.key,
    required this.bannerImages,
  });

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  late PageController _controller;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      int next = (_controller.page!.round() + 1) % widget.bannerImages.length;

      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.bannerImages.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 1.0;

                  if (_controller.position.haveDimensions) {
                    value = (_controller.page! - index).abs();
                    value = (1 - (value * 0.3)).clamp(0.7, 1.0);
                  }

                  return Opacity(
                    opacity: value, // fade effect
                    child: Transform.scale(
                      scale: value, // scale effect
                      child: child,
                    ),
                  );
                },
                child: FixedBoxImage(
                  imagePath: widget.bannerImages[index],
                  width: double.infinity,
                  height: 180,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.bannerImages.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: const Color(0xFFF2D27A), //0xFFF2D27A
            dotColor: const Color(0xFFE1BC4E), //0xFFE1BC4E
          ),
        ),
      ],
    );
  }
}
