import 'package:flutter/material.dart';

void main() {
  runApp(const OpenThePathApp());
}

class OpenThePathApp extends StatelessWidget {
  const OpenThePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open The Path',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Open The Path'),
        ),
        body: const Center(
          child: Text(
            'مرحبا بك في Open The Path',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
