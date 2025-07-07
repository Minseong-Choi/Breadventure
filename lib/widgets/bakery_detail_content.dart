import 'package:flutter/material.dart';
import '../screens/bakery_review_page.dart';

class BakeryDetailContent extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const BakeryDetailContent({
    super.key,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    // ⭐️ 빵집 이름도 하드코딩
    const String bakeryName = '밀도 서울숲점';
    const double averageRating = 4.1;

    final List<String> imagePaths = [
      'lib/assets/images/breads/LBM.jpg',
      'lib/assets/images/breads/MDCream.jpg',
      'lib/assets/images/breads/ML.jpg',
    ];

    final List<Map<String, dynamic>> reviews = [
      {
        'profileImage': 'lib/assets/images/cats/cat_gray.png',
        'username': '빵덕후',
        'rating': 5,
        'comment': '여기 빵 정말 맛있어요!',
      },
      {
        'profileImage': 'lib/assets/images/cats/cat_brown.png',
        'username': '빵순이',
        'rating': 4,
        'comment': '분위기도 좋고 재방문 의사 있음',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🥐 빵집 이름 + 좋아요 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🥐 $bakeryName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: onLikeToggle,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            Row(
              children: List.generate(5, (index) {
                if (index < averageRating.floor()) {
                  return const Icon(Icons.star, color: Colors.amber, size: 16);
                } else {
                  return const Icon(Icons.star_border, color: Colors.amber, size: 16);
                }
              }),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 운영시간, 주소, 전화번호
        const Text('⏰ 운영시간: 09:00 ~ 20:00 (매주 월요일 휴무)'),
        const SizedBox(height: 8),
        const Text('📍 서울 성동구 서울숲2길 32-14'),
        const SizedBox(height: 8),
        const Text('📞 02-1234-5678'),

        const SizedBox(height: 20),

        // 사진첩 제목
        const Text(
          '📸 매장 사진',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // 사진첩 그리드
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imagePaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final path = imagePaths[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.black,
                    insetPadding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: InteractiveViewer(
                        child: Image.asset(path, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // 메뉴
        const Text(
          '메뉴',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('• 쪽파크림치즈베이글'),
        const Text('• 명란바게트'),
        const Text('• 크림빵'),

        const SizedBox(height: 20),

        // 리뷰 제목
        Row(
            children: [
              const Text(
                '리뷰',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BakeryReviewPage()
                  )
                );
              }, icon: const Icon(Icons.add))
            ]
        ),


        const SizedBox(height: 12),

        // 리뷰 리스트
        Column(
          children: reviews.map((review) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      review['profileImage'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 아이디, 별점, 리뷰 텍스트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 아이디 + 별점
                        Row(
                          children: [
                            Text(
                              review['username'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(
                                5,
                                    (index) => Icon(
                                  index < review['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // 리뷰 한 줄 텍스트
                        Text(
                          review['comment'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
