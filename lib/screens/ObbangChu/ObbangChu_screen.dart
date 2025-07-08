import 'package:flutter/material.dart';
import '../bakery_detail_page.dart';
// BakeryDetailPage는 상세페이지
// 기존 PlaceholderPage는 삭제 혹은 주석처리 가능

class ObbangChuScreen extends StatelessWidget {
  const ObbangChuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    final String weather = "해가 쨍쨍한";
    final String breadName = "크림빵";
    final String bakeryName = "고양이 베이커리";
    final String breadImageUrl = "lib/assets/images/breads/CreamBread.jpg";

    return Scaffold(
      body: Center( // 화면 중앙에 전체 배치
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 말풍선 + 꼬리
            Column(
              children: [
                // 말풍선 (Stack + CustomPaint 꼬리)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "오늘은 $weather 날씨야!\n이런 날엔 $breadName 어때?",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 20,
                      child: CustomPaint(
                        painter: SpeechBubbleTailPainter(),
                        child: const SizedBox(
                          width: 20,
                          height: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 10),
                  // 고양이 이미지
                  Image.asset(
                    'lib/assets/images/cats/cat_brown.png',
                    width: 140,
                    height: 140,
                  ),
                ],
            ),
              const SizedBox(height: 24),
              // 추천 빵 카드
              GestureDetector(
                onTap: () {
                  // ✅ BakeryDetailPage로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BakeryDetailPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        // 빵 이미지 (크기 많이 확대)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            breadImageUrl,
                            width: 240,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 빵 정보 (아래에 위치)
                        Text(
                          breadName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          bakeryName,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

// 말풍선 꼬리 painter
class SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.orange[100]!;
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

