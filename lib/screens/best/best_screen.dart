import 'package:flutter/material.dart';

class BestScreen extends StatelessWidget {
  const BestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bakeries = [
      {
        'name': '런던베이글',
        'menu': '쫄파치즈베이글',
        'rating': 4.7,
        'image': "https://example.com/image1.jpg",
      },
      {
        'name': '성심당',
        'menu': '명란바게트',
        'rating': 4.9,
        'image': 'https://example.com/image2.jpg',
      },
      {
        'name': '밀도',
        'menu': '크림빵',
        'rating': 4.8,
        'image': 'https://example.com/image3.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('BEST 빵집')),
      body: ListView.builder(
        itemCount: bakeries.length,
        itemBuilder: (context, index) {
          final bakery = bakeries[index];
          return Stack(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🥐 이미지
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        bakery['image'] as String,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey,
                          height: 180,
                          child: const Center(child: Icon(Icons.broken_image, size: 40)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏠 빵집 이름
                          Text(
                            bakery['name'] as String,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          // 🍞 메뉴
                          Text(
                            bakery['menu'] as String,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          // ⭐️ 평점
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${bakery['rating']}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ⭐️ 순위 뱃지
              Positioned(
                top: 16,
                left: 32,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}위',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
