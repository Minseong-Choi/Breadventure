import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import '../../service/location_monitor.dart';

Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    print('❌ 위치 권한이 거부되었습니다.');
  }
}

class KakaoMapWidget extends StatefulWidget {
  const KakaoMapWidget({Key? key}) : super(key: key);

  @override
  State createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  late final WebViewController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    LocationMonitor.startMonitoring(); // 앱 실행 중 실시간 위치 모니터링
  }

  @override
  void dispose() {
    LocationMonitor.stopMonitoring(); // 앱 종료 시 모니터링 중지
    super.dispose();
  }

  Future<void> _initializeWebView() async {
    await _requestLocationPermission();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'LocationRequest',
        onMessageReceived: (message) {
          print('📡 JS → Flutter 위치 요청 받음');
          _sendLocationToJS();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            setState(() => _ready = true);

            // JS에서 채널 사용할 수 있도록 전역 함수 등록
            await _controller.runJavaScript('''
          window.requestLocationFromFlutter = function() {
            if (window.LocationRequest) {
              window.LocationRequest.postMessage("get");
            }
          };
        ''');
          },
        ),
      )
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse('https://kakao-map-bread-ijto.vercel.app'));
  }

  Future<void> _sendLocationToJS() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final lat = position.latitude;
      final lng = position.longitude;

      final js = 'updateUserLocationFromFlutter($lat, $lng);';
      await _controller.runJavaScript(js);
    } catch (e) {
      print("위치 전달 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(
      controller: _controller,
    );
  }
}
