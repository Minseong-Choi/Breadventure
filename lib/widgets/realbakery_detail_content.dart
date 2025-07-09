import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../models/bakery.dart';

/// 전역 즐겨찾기 저장 클래스
class FavoriteManager {
  static List<String> favoriteBakeryIds = [];
}

/// JSON 파일에서 빵집 전체 데이터 불러오기
Future<List<Bakery>> loadBakeryData() async {

  final String jsonString =
  await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
  final Map<String, dynamic> decoded = json.decode(jsonString);
  final List<dynamic> jsonList = decoded['documents'];
  return jsonList.map((json) => bakery_model.Bakery.fromJson(json)).toList();
}


/// 상세페이지 내용 구성 위젯
class BakeryDetailContent extends StatelessWidget {
  final bakery_model.Bakery bakery;
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
    final List<bakery_model.Comment> reviews = bakery.comments;
    final String address = bakery.address;


    return Scaffold(
      appBar: AppBar(
        title: const Text('빵집 상세페이지'),
        backgroundColor: Color(0xFFFCEAD9),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀 + 좋아요 버튼
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
                    color: Colors.red,
                  ),
                  onPressed: (){
                    print("🦛즐겨찾기한 식당 아이디 ${FavoriteManager.favoriteBakeryIds}");
                    onLikeToggle();

                  },
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
                    return Icon(
                      index < averageRating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('⏰ 운영시간:'),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bakery.openingHours.map((hour) {
                return Text('${hour.day}-${hour.time}');
              }).toList(),
            ),
            Text('📍 $address'),
            const SizedBox(height: 8),
            Text('📞 $phone'),
            const SizedBox(height: 20),

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
            const Text(
              '메뉴',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...bakery.menu.map((item) => Text('• ${item.name}')),

            const SizedBox(height: 20),
            const Text(
              '리뷰',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    review.reviewerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
      ),
    );
  }
}