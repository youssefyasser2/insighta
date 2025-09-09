import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessfulPage extends StatefulWidget {
  final DateTime date;
  final String time;
  const BookingSuccessfulPage({
    Key? key,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  State<BookingSuccessfulPage> createState() => _BookingSuccessfulPageState();
}

class _BookingSuccessfulPageState extends State<BookingSuccessfulPage>
    with TickerProviderStateMixin {
  String _formatDate(DateTime date) {
    // مثلاً: 18 July
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  late AnimationController _checkmarkController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _checkmarkAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Create animations
    _checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkmarkController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    // Start animations sequence
    _startAnimations();

    // Navigate to home after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/home'); // Navigate to home using go_router
      }
    });
  }

  void _startAnimations() async {
    // Start scale animation first
    await _scaleController.forward();

    // Then start checkmark and fade animations simultaneously
    _checkmarkController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated title
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _fadeController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: const Text(
                  'Booking successful',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Animated checkmark
            ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedBuilder(
                animation: _checkmarkAnimation,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF20B2AA), // Teal color
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF20B2AA).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Transform.scale(
                      scale: _checkmarkAnimation.value,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 80),

            // Animated booking details
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _fadeController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_formatDate(widget.date)}, ${widget.time}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '133 Main ST, USA',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Loading indicator or navigation hint
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey[400]!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Redirecting to home...',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
