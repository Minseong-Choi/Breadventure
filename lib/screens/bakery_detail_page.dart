import 'package:flutter/material.dart';
import '../models/bakery.dart';
import '../widgets/realbakery_detail_content.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class BakeryDetailPage extends StatefulWidget {
  const BakeryDetailPage({super.key});

  @override
  State<BakeryDetailPage> createState() => _BakeryDetailPageState();
}

class _BakeryDetailPageState extends State<BakeryDetailPage> {
  bool isLiked = false;

  Future<List<Bakery>> loadBakeryData() async {
    final String jsonString =
    await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
    final Map<String, dynamic> decoded = json.decode(jsonString);
    final List<dynamic> jsonList = decoded['documents'];
    return jsonList.map((json) => Bakery.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bakery>>(
      future: loadBakeryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('에러: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('데이터 없음')),
          );
        }

        final bakery = snapshot.data![0]; // 첫 번째 빵집

        return Scaffold(
          backgroundColor: Colors.white,
          body: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BakeryDetailContent(
                bakery: bakery, // ✅ 이제 에러 안 남
                isLiked: isLiked,
                onLikeToggle: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
