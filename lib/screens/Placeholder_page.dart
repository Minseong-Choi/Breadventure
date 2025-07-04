import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상세 페이지(임시)')),
      body: const Center(
        child: Text('여기에 빵집 상세 정보가 표시될 예정입니다.'),
      ),
    );
  }
}
