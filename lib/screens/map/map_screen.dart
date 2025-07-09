import 'package:flutter/material.dart';
import '../bottomSheet/bottomSheet.dart';
import 'package:breadventure/screens/map/kakao_map_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  void _showRestaurantSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 테두리 둥글게 보이게 하려면 이거 필요
      builder: (context) => const RestaurantBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Map 위젯
          Expanded(
            child: KakaoMapWidget(key: UniqueKey()),
          ),
          // 버튼
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
                '',
              style: const TextStyle(
                fontSize: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

