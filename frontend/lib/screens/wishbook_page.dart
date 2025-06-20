import 'package:flutter/material.dart';

class WishbookPage extends StatelessWidget {
  const WishbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishbook')),
      body: const Center(
        child: Text('Welcome to the Wishbook!'),
      ),
    );
  }
}
