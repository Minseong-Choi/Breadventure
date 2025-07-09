import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/bakery.dart' as bakery_model;
import '../models/comment.dart' as local_comment;
import '../screens/bakery_review_page.dart';
import '../utils/review_storage.dart';

// 데이터 로드 함수
Future<List<bakery_model.Bakery>> loadBakeryData() async {
  final String jsonString =
  await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
  final Map<String, dynamic> decoded = json.decode(jsonString);
  final List<dynamic> jsonList = decoded['documents'];
  return jsonList.map((json) => bakery_model.Bakery.fromJson(json)).toList();
}

// 상세 페이지
class BakeryDetailPage extends StatelessWidget {
  const BakeryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bakery_model.Bakery>>(
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
    final List<bakery_model.OpeningHour> openingHours = bakery.openingHours;

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
                      builder: (context) => BakeryReviewPage(
                        onSubmit: (rating, reviewText, selectedPhoto) async {
                          await ReviewStorage.insertAtFront({
                            'reviewer_name' : '빵냥이대왕',
                            'reviewer_grade' : rating.toString(),
                            'reviewer_photo' : selectedPhoto?.path ?? '../assets/images/cats/cat_black.jpg',
                            'reviewer_comment' : reviewText,
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ➊ 로컬 JSON 에서 가져온 사용자 리뷰 먼저 출력
          FutureBuilder<List<local_comment.Comment>>(
            future: ReviewStorage.loadReviews(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData || snap.data!.isEmpty) {
                return const SizedBox(); // 저장된 리뷰가 없으면 빈 공간
              }
              final userReviews = snap.data!;

              return Column(
                children: userReviews
                    .map((r) => _buildLocalReviewTile(r))
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 12),

          // ➋ 그리고 기존 빵집 데이터에 포함된 리뷰 출력
          Column(
            children: reviews
                .map((r) => _buildBakeryReviewTile(r))
                .toList(),
          ),
        ],
      ),
    );
  }
  // (1) bakery_model.Comment 전용
  Widget _buildBakeryReviewTile(bakery_model.Comment r) {
    return _commonReviewTile(
      name: r.reviewerName,
      grade:  r.reviewerGrade,
      photo:  r.reviewerPhoto,
      text:   r.reviewerComment,
    );
  }

// (2) local_comment.Comment 전용
  Widget _buildLocalReviewTile(local_comment.Comment r) {
    return _commonReviewTile(
      name: r.reviewerName,
      grade:  r.reviewerGrade,
      photo:  r.reviewerPhoto,
      text:   r.reviewerComment,
    );
  }
  Widget _buildPhoto(String photo) {
    if (photo.isEmpty) {
      return const SizedBox(width:40, height:40);
    }
    if (photo.startsWith('http')) {
      // 네트워크 이미지
      return Image.network(
        photo,
        width: 40, height: 40, fit: BoxFit.cover,
        errorBuilder: (_,__,___) => const SizedBox(width:40, height:40),
      );
    }
    print("로컬 사진 확인");
    // 그 외엔 로컬 파일로 간주
    return Image.file(
      File(photo),
      width: 40, height: 40, fit: BoxFit.cover,
      errorBuilder: (_,__,___) => const SizedBox(width:40, height:40),
    );
  }

  // 리뷰 하나를 화면에 표시하는 동일 디자인 함수
  Widget _commonReviewTile({
    required String name,
    required String grade,
    required String photo,
    required String text,
  }) {
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
            child: _buildPhoto(photo),
          ),
          const SizedBox(width:12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width:8),
                    Row(
                      children: List.generate(5, (i) {
                        // 소수점 문자열도 처리할 수 있도록 double로 파싱 후 floor() 해서 정수로 변환
                        final starCount = (double.tryParse(grade) ?? 0).floor();
                        final filled   = i < starCount;
                        return Icon(
                          filled ? Icons.star : Icons.star_border,
                          size: 16, color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height:6),
                Text(text, maxLines:1, overflow:TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}