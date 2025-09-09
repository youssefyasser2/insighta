import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NavigationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const NavigationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.onNext,
    required this.onPrevious,
  });

  static const double _buttonSize = 56.0;
  static const Color _rightBgColor = Color(0xFF076372);
  static final Color _leftBgColor = Colors.grey.shade200;

  Widget _buildLeftButton() {
    return Semantics(
      label: 'Previous Button',
      child: Container(
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _leftBgColor,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onPrevious,
        ),
      ),
    );
  }

  Widget _buildRightButton() {
    return Semantics(
      label: 'Next Button',
      child: Container(
        width: _buttonSize,
        height: _buttonSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: _rightBgColor,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: onNext,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            currentPage > 0 ? _buildLeftButton() : const SizedBox(width: _buttonSize),
            SmoothPageIndicator(
              controller: pageController,
              count: totalPages > 0 ? totalPages : 1,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: constraints.maxWidth * 0.2,
                  height: 10,
                  color: _rightBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                dotDecoration: DotDecoration(
                  width: constraints.maxWidth * 0.2,
                  height: 10,
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                spacing: 8.0,
              ),
            ),
            _buildRightButton(),
          ],
        );
      },
    );
  }
}