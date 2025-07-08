import 'package:flutter/material.dart';
import '../models/bakery.dart';
import '../widgets/realbakery_detail_content.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class BakeryDetailPage extends StatefulWidget {
  final String bakeryId;

  const BakeryDetailPage({super.key, required this.bakeryId});

  @override
  State<BakeryDetailPage> createState() => _BakeryDetailPageState();
}

class _BakeryDetailPageState extends State<BakeryDetailPage> {
  bool isLiked = false;

  Future<Bakery?> loadBakeryById(String id) async {
    final String jsonString =
    await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
    final Map<String, dynamic> decoded = json.decode(jsonString);
    final List<dynamic> jsonList = decoded['documents'];
    final List<Bakery> bakeries =
    jsonList.map((json) => Bakery.fromJson(json)).toList();

    return bakeries.firstWhere((b) => b.id == widget.bakeryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Bakery?>(
      future: loadBakeryById(widget.bakeryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('에러: ${snapshot.error}')));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text('빵집을 찾을 수 없음')));
        }

        final bakery = snapshot.data!;
        return Scaffold(
          body: BakeryDetailContent(
            bakery: bakery,
            isLiked: isLiked,
            onLikeToggle: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
        );
      },
    );
  }
}
