import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuggestScreen extends StatelessWidget {
  const SuggestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    Scaffold scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        foregroundColor: Colors.black,
        title: Text(
          'Suggest',
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Responsive text
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: const Center(child: Text('Suggest Screen')),
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: scaffold,
    );
  }
}
