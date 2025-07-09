import 'package:flutter/material.dart';

class LanguageTestPage extends StatelessWidget {
  const LanguageTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the scrollable content
        child: SizedBox(
          height: 1500, // Set total scrollable height
          child: Stack(
            children: [
              // Background Image 1
              Positioned(
                top: 100,
                left: 20,
                child: Image.asset(
                  'assets/gradients/grad_1.png',
                  width: 100,
                ),
              ),
              // Background Image 2
              Positioned(
                top: 500,
                right: 30,
                child: Image.asset(
                  'assets/gradients/grad_2.png',
                  width: 150,
                ),
              ),

              Positioned(
                top: 900,
                right: 30,
                child: Image.asset(
                  'assets/gradients/grad_2.png',
                  width: 150,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20,
                child: Image.asset(
                  'assets/gradients/grad_1.png',
                  width: 100,
                ),
              ),
              // Your foreground content
              Positioned.fill(
                child: Column(
                  children: [
                    const SizedBox(height: 200),
                    const Text(
                      'Scroll Down',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 1000),
                    const Text(
                      'Bottom content',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
