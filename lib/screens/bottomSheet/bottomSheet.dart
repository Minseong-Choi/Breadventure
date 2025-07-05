import 'package:flutter/material.dart';

// 임시 리뷰 작성 페이지
class ReviewWritePage extends StatelessWidget {
  const ReviewWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리뷰 작성')),
      body: const Center(child: Text('리뷰 작성 페이지 - 추후 구현')),
    );
  }
}

class RestaurantBottomSheet extends StatefulWidget {
  const RestaurantBottomSheet({super.key});

  @override
  State<RestaurantBottomSheet> createState() => _RestaurantBottomSheetState();
}

class _RestaurantBottomSheetState extends State<RestaurantBottomSheet> {
  final List<String> imagePaths = [
    'lib/assets/images/LBM.jpg',
    'lib/assets/images/MDCream.jpg',
    'lib/assets/images/ML.jpg',
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'profileImage': 'lib/assets/images/grayCat.png',
      'username': '빵덕후',
      'rating': 5,
      'comment': '여기 빵 정말 맛있어요!',
    },
    {
      'profileImage': 'lib/assets/images/orangeCat.png',
      'username': '빵순이',
      'rating': 4,
      'comment': '분위기도 좋고 재방문 의사 있음',
    },
  ];

  bool isLiked = false; // 하트 버튼 상태

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 핸들바
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // 상단 - 가게명 & 평점 & 좋아요 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🥐 밀도 서울숲점',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        const Text('4.5'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 정보
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

                const SizedBox(height: 12),

                // 메뉴 제목
                const Text(
                  '메뉴',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('• 쪽파크림치즈베이글'),
                const SizedBox(height: 4),
                const Text('• 명란바게트'),
                const SizedBox(height: 4),
                const Text('• 크림빵'),
                const SizedBox(height: 12),

                const SizedBox(height: 12),

                // 리뷰 제목과 + 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '리뷰',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReviewWritePage(),
                          ),
                        );
                      },
                    ),
                  ],
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
            ),
          ),
        );
      },
    );
  }
}
