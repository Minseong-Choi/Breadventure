import 'package:flutter/material.dart';
import '../widgets/bakery_detail_content.dart';
import 'bakery_review_page.dart';

class BakeryDetailPage extends StatefulWidget {
  const BakeryDetailPage({super.key});

  @override
  State<BakeryDetailPage> createState() => _BakeryDetailPageState();
}

class _BakeryDetailPageState extends State<BakeryDetailPage> {
  bool isLiked = false;

  // 초기(샘플) 리뷰 목록
  List<Map<String, dynamic>> reviews = [
    {
      'profileImage': 'lib/assets/images/cats/cat_gray.png',
      'username': '빵덕후',
      'rating': 4,
      'comment': '여기 빵 정말 맛있어요!',
    },
    {
      'profileImage': 'lib/assets/images/cats/cat_brown.png',
      'username': '빵순이',
      'rating': 4,
      'comment': '분위기도 좋고 재방문 의사 있음',
    },
  ];

  void _onAddReviewPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BakeryReviewPage(
          onSubmit: (rating, comment) {
            setState(() {
              reviews.add({
                'profileImage': 'lib/assets/images/cats/cat_black.png',
                'username': '빵냥이대왕',
                'rating': rating,
                'comment': comment,
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('빵집 상세')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BakeryDetailContent(
          isLiked: isLiked,
          onLikeToggle: () => setState(() => isLiked = !isLiked),
          reviews: reviews,
          onAddReviewPressed: _onAddReviewPressed,
        ),
      ),
    );
  }
}
