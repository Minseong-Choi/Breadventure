import 'package:flutter/material.dart';
import '../widgets/bakery_detail_content.dart';

class BakeryDetailPage extends StatefulWidget {
  const BakeryDetailPage({super.key});

  @override
  State<BakeryDetailPage> createState() => _BakeryDetailPageState();
}

class _BakeryDetailPageState extends State<BakeryDetailPage> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('🥐 빵집 상세페이지'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Scrollbar( // ⭐️ 스크롤바 표시
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BakeryDetailContent(
            isLiked: isLiked,
            onLikeToggle: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
        ),
      ),
    );
  }
}
