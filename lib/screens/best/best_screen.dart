import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../../models/bakery.dart';
import '../bakery_detail_page.dart';
import 'dart:io';

class BestScreen extends StatelessWidget {
  const BestScreen({super.key});

  // Top 10 빵집 로딩
  Future<List<Bakery>> loadTopBakeries() async {
    final String jsonString =
    await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
    final Map<String, dynamic> decoded = json.decode(jsonString);
    final List<dynamic> jsonList = decoded['documents'];

    final List<Bakery> bakeries =
    jsonList.map((json) => Bakery.fromJson(json)).toList();

    // 댓글 많은 순 정렬 후 10개만
    bakeries.sort((a, b) => b.comments.length.compareTo(a.comments.length));
    return bakeries.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking (후기순)'),
        backgroundColor:Color(0xFFFCEAD9),
        centerTitle: true, // 제목 가운데 정렬
      ),
      body: FutureBuilder<List<Bakery>>(
        future: loadTopBakeries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('데이터 없음'));
          }

          final topBakeries = snapshot.data!;


          return ListView.builder(
            itemCount: topBakeries.length,
            itemBuilder: (context, index) {
              final bakery = topBakeries[index];
              final String rawUrl = bakery.photos.isNotEmpty ? bakery.photos.first.trim() : '';
              final String photoUrl = rawUrl.isNotEmpty ? Uri.parse(rawUrl).toString() : '';



              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BakeryDetailPage(bakeryId: bakery.id),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: photoUrl.isNotEmpty
                                ? Image.network(
                              photoUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey,
                                height: 180,
                                child: const Center(child: Icon(Icons.broken_image)),
                              ),
                            )
                                : Image.asset(
                              'lib/assets/images/cats/defaultCat.png', // 로컬 디폴트 이미지 경로
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bakery.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  bakery.menu.isNotEmpty
                                      ? bakery.menu.first.name
                                      : '대표 메뉴 없음',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(bakery.totalStar.toStringAsFixed(1)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
