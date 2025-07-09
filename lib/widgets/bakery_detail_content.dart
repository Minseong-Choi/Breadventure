import 'package:flutter/material.dart';

/// 빵집 상세 내용 + 리뷰 리스트 + 리뷰 추가 버튼
class BakeryDetailContent extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLikeToggle;
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onAddReviewPressed;

  const BakeryDetailContent({
    super.key,
    required this.isLiked,
    required this.onLikeToggle,
    required this.reviews,
    required this.onAddReviewPressed,
  });

  @override
  Widget build(BuildContext context) {
    const String bakeryName = '밀도 서울숲점';
    const double averageRating = 4.1;

    final List<String> imagePaths = [
      'lib/assets/images/breads/LBM.jpg',
      'lib/assets/images/breads/MDCream.jpg',
      'lib/assets/images/breads/ML.jpg',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 빵집 이름 + 좋아요
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🥐 $bakeryName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
              color: isLiked ? Colors.red : Colors.grey,
              onPressed: onLikeToggle,
            ),
          ],
        ),
        const SizedBox(height: 4),

        // 평점
        Row(
          children: [
            Text(averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Row(
              children: List.generate(5, (i) {
                return Icon(
                  i < averageRating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 매장 사진 그리드
        const Text('📸 매장 사진', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imagePaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, idx) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePaths[idx], fit: BoxFit.cover),
            );
          },
        ),

        const SizedBox(height: 20),
        const Text('메뉴', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('• 쪽파크림치즈베이글'),
        const Text('• 명란바게트'),
        const Text('• 크림빵'),

        const SizedBox(height: 20),

        // 리뷰 섹션
        Row(
          children: [
            const Text('리뷰', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAddReviewPressed,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Column(
          children: reviews.map((r) {
            // 맵에서 필요한 값 뽑아오기
            final profilePath = r['profileImage'] as String? ?? '';
            final username    = r['username']     as String? ?? '익명';
            final rating      = r['rating']       as int?    ?? 0;
            final comment     = r['comment']      as String? ?? '';

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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(profilePath),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 사용자명 + 별점
                        Row(
                          children: [
                            Text(
                              username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // 후기가 길면 줄임
                        Text(
                          comment,
                          maxLines: 2,
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
