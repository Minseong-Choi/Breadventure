import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../models/bakery.dart';
import 'notification_service.dart';

class LocationMonitor {
  static Timer? _timer;
  static List<Bakery> bakeries = [];
  static Set<String> notifiedBakeries = {};

  // 1. JSON 데이터 로드
  Future<List<Bakery>> loadBakeryData() async {
    try {
      final String jsonString =
      await rootBundle.loadString('lib/assets/data/bakery_data_enriched.json');
      final Map<String, dynamic> decoded = json.decode(jsonString);
      final List<dynamic> jsonList = decoded['documents'];
      return jsonList.map((json) => Bakery.fromJson(json)).toList();
    } catch (e) {
      print('❌ 빵집 데이터 로딩 실패: $e');
      return [];
    }
  }

  // 2. 타이머 기반 위치 확인 시작
  static Future<void> startMonitoring() async {
    const distanceThreshold = 250; // 50m
    const checkInterval = Duration(seconds: 10);

    print('📡 타이머 기반 위치 모니터링 시작');

    // 빵집 데이터 로드
    try {
      bakeries = await LocationMonitor().loadBakeryData();
      print('✅ 빵집 데이터: ${bakeries.length}개');
    } catch (e) {
      print('❌ 빵집 데이터 초기화 실패: $e');
      return;
    }

    // 3. 타이머 시작
    _timer = Timer.periodic(checkInterval, (_) async {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        print('[📍] 위치 수신: ${position.latitude}, ${position.longitude}');

        for (var bakery in bakeries) {
          final double lat = double.tryParse(bakery.y.toString()) ?? 0.0; // ✅ 위도
          final double lng = double.tryParse(bakery.x.toString()) ?? 0.0; // ✅ 경도

          if (lat == null || lng == null) {
            print('⚠️ 위도/경도 변환 실패: ${bakery.name}');
            continue;
          }

          final distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            lat,
            lng,
          );

          if (bakery.name.contains('카이스트')) {
            print('[🏠] ${bakery.name}까지 거리: ${distance.toStringAsFixed(1)}m');
          }

          if (distance <= distanceThreshold && !notifiedBakeries.contains(bakery.name)) {
            await sendPushNotification(bakery.name);
            notifiedBakeries.add(bakery.name);

            Timer(const Duration(minutes: 5), () {
              notifiedBakeries.remove(bakery.name); // 해당 빵집만 제거
            });
          }
        }
      } catch (e) {
        print('❌ 위치 측정 실패: $e');
      }
    });
  }

  // 4. 종료 함수
  static void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    print('🛑 위치 모니터링 중지');
  }
}
