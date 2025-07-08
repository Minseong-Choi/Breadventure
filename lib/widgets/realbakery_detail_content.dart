import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/bakery.dart';
import '../screens/bakery_review_page.dart';

// 데이터 로드 함수
Future<List<Bakery>> loadBakeryData() async {
  final String jsonString =
    await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
  final Map<String, dynamic> decoded = json.decode(jsonString);
  final List<dynamic> jsonList = decoded['documents'];
  return jsonList.map((json) => Bakery.fromJson(json)).toList();
}
// 상세 페이지
class BakeryDetailPage extends StatelessWidget {
  const BakeryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bakery>>(
      future: loadBakeryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('데이터 없음'));
        }

        final bakery = snapshot.data![0]; // 첫 번째 빵집 데이터 사용
        return BakeryDetailContent(
          bakery: bakery,
          isLiked: false,
          onLikeToggle: () {},
        );
      },
    );
  }
}

// 실제 빵집 내용 위젯
class BakeryDetailContent extends StatelessWidget {
  final Bakery bakery;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const BakeryDetailContent({
    super.key,
    required this.bakery,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final String bakeryName = bakery.name;
    final double averageRating = bakery.totalStar;
    final List<String> imagePaths = bakery.photos.take(3).toList();
    final String phone = bakery.phone;
    final List<Comment> reviews = bakery.comments;
    final String address = bakery.address;
    final List<OpeningHour> openingHours = bakery.openingHours;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🥐 $bakeryName',
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              Row(
                children: List.generate(5, (index) {
                  if (index < averageRating.floor()) {
                    return const Icon(Icons.star, color: Colors.amber, size: 16);
                  } else {
                    return const Icon(Icons.star_border,
                        color: Colors.amber, size: 16);
                  }
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '⏰ 운영시간:',
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bakery.openingHours.map((hour){
              return Text('${hour.day}-${hour.time}');
            }).toList(),
          ),
          Text('📍 $address'),
          const SizedBox(height: 8),
          Text('📞 $phone'),
          const SizedBox(height: 20),

          // 사진첩
          const Text(
            '📸 매장 사진',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: imagePaths.map((url) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // 메뉴
          const Text(
            '메뉴',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...bakery.menu.map((item) => Text('• ${item.name}')),

          const SizedBox(height: 20),

          // 리뷰
          Row(
            children: [
              const Text(
                '리뷰',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BakeryReviewPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        review.reviewerPhoto,
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
                                review.reviewerName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: List.generate(
                                  5,
                                      (index) => Icon(
                                    index < double.parse(review.reviewerGrade).floor()
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
                            review.reviewerComment,
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
    );
  }
}
