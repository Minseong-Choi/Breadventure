import 'package:flutter/material.dart';
import '../Placeholder_page.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
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

    final List<Map<String, String>> bakeries = [
      {
        'name': '런던베이글',
        'menu': '쪽파크림치즈베이글',
        'rating': '4.7',
        'image': 'lib/assets/images/breads/LBM.jpg',
      },
      {
        'name': '성심당',
        'menu': '명란바게트',
        'rating': '4.9',
        'image': 'lib/assets/images/breads/ML.jpg',
      },
      {
        'name': '밀도',
        'menu': '크림빵',
        'rating': '4.8',
        'image': 'lib/assets/images/breads/MDCream.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 알림 스위치
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🥐 빵 레이더 알림 받기',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 프로필 + 즐겨찾기 + 후기
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '아기빵냥이 yihaleyi',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('후기 3 개 즐겨찾기 2 개'),
                    const SizedBox(height: 8),
                    Image.asset(
                      'lib/assets/images/cats/cat_brown.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '내 즐겨찾기',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...bakeries.map((bakery) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlaceholderPage(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  bakery['image']!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bakery['name']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(bakery['menu']!),
                                  Text('⭐ ${bakery['rating']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 12),
                    const Text(
                      '내가 쓴 후기',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...reviews.map((review) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlaceholderPage(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                        ),
                      );
                    }).toList(),
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
