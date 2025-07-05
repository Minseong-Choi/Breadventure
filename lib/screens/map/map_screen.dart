import 'package:flutter/material.dart';
import 'package:breadventure/screens/map/kakao_map_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카카오맵 예제'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: KakaoMapWidget(),
      ),
    );
  }
}




