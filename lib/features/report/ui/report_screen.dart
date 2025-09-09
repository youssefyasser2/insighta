import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/report/ui/report_screen_body.dart'; // Required for context.go and context.canPop

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        foregroundColor: Colors.black,
        title: Text(
          'report',
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(); // Navigate back if possible
            } else {
              context.go('/home'); // Fallback to home route
            }
          },
        ),
      ),
      body: SafeArea(child: ReportScreenBody()),
    );
  }
}
