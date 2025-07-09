import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/bakery.dart';
import '../bakery_detail_page.dart';
import '../../widgets/realbakery_detail_content.dart'
    show FavoriteManager, loadBakeryData;

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _notificationsEnabled = true;
  Map<String, dynamic>? userData;
  List<Bakery> allBakeries = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadBakeryData().then((data) {
      setState(() {
        allBakeries = data;
      });
    });
  }

  Future<void> loadUserData() async {
    final String jsonString =
    await rootBundle.loadString('lib/assets/data/userData.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      userData = jsonMap['users'][2]; // 0~2 숫자 바꾸면 다른 유저로 테스트 가능
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // 강제로 build 재호출
  }
  Widget build(BuildContext context) {
    debugPrint("💥 MyScreen build called");
    print("🐏현재 즐겨찾기 목록: ${FavoriteManager.favoriteBakeryIds}");
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final reviews = userData!['reviews'] as List;
    final profileImage = userData!['profileImage'];
    final username = userData!['username'];
    final favoriteBakeries = allBakeries
        .where((b) => FavoriteManager.favoriteBakeryIds.contains(b.id))
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🥐 알림 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '🥐 빵 레이더 알림 받기',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: '반경 200m 내에 빵이 있으면 알림을 보내준다냥🐱!',
                        child:
                        Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _notificationsEnabled ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                          _notificationsEnabled ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              /// 🐱 프로필 및 기본 정보
              Center(
                child: Column(
                  children: [
                    Text(
                      '$username',
                      style:
                      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('후기 ${reviews.length}개 즐겨찾기 ${favoriteBakeries.length}개'),
                    const SizedBox(height: 8),
                    Image.asset(profileImage,
                        width: 200, height: 200, fit: BoxFit.cover),
                    const SizedBox(height: 16),

                    /// 🧡 최애 빵집
                    const Text('빵냥이의 최애빵집',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    if (favoriteBakeries.isEmpty)
                      const Text('즐겨찾기한 빵집이 없다냥 😿')
                    else
                      Column(
                        children: favoriteBakeries.map((bakery) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BakeryDetailPage(bakeryId: bakery.id),
                                ),
                              );
                              setState(() {}); // 돌아오면 다시 그리기
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
                                    child: Image.network(
                                      bakery.photos.isNotEmpty
                                          ? bakery.photos.first
                                          : '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.bakery_dining),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(bakery.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      if (bakery.menu.isNotEmpty)
                                        Text(bakery.menu.first.name),
                                      Text('⭐ ${bakery.totalStar.toStringAsFixed(1)}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 24),

                    /// 🍞 리뷰 슬라이더
                    const Text('빵냥이의 빵로그',
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          final imagePath = review['image'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Image.asset(imagePath,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                child: Image.asset(
                                                  profileImage,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(username,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                        const SizedBox(width: 8),
                                                        Row(
                                                          children:
                                                          List.generate(
                                                            5,
                                                                (starIndex) => Icon(
                                                              starIndex <
                                                                  review['rating']
                                                                  ? Icons.star
                                                                  : Icons
                                                                  .star_border,
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
                                                      maxLines: 3,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  imagePath,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
