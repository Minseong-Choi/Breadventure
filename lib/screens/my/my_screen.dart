import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../Placeholder_page.dart';
//userData = jsonMap['users'][2]; 안의 숫자 0-2까지 바꾸면서 유저 바꿔볼 수 있음

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _notificationsEnabled = true;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final String jsonString = await rootBundle.loadString('lib/assets/data/userData.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // 예시로 첫 번째 유저를 가져옴
    setState(() {
      userData = jsonMap['users'][2];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final reviews = userData!['reviews'] as List;
    final favorites = userData!['favorites'] as List;
    final profileImage = userData!['profileImage'];
    final username = userData!['username'];

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
                        child: Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.grey[600],
                        ),
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
                          color: _notificationsEnabled ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                ],
              ),

              const SizedBox(height: 32),

              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      '$username',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('후기 ${reviews.length} 개 즐겨찾기 ${favorites.length} 개'),
                    const SizedBox(height: 8),
                    Image.asset(
                      profileImage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '빵냥이의 최애빵집',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...favorites.map((bakery) {
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
                                  bakery['image'],
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
                                    bakery['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(bakery['menu']),
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
                      '빵냥이의 빵로그',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 110,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(reviews.length, (index) {
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child:AspectRatio(
                                                aspectRatio:1,
                                                child: Image.asset(
                                                    imagePath, fit: BoxFit.cover
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Image.asset(
                                                      profileImage,
                                                      fit: BoxFit.cover,
                                                    ),
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
                                                            username,
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Row(
                                                            children: List.generate(
                                                              5,
                                                                  (starIndex) => Icon(
                                                                starIndex < review['rating']
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
                                                        maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
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
                          }),
                        ),
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
