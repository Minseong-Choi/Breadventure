import 'package:flutter/material.dart';
import 'dart:math';
import '../bakery_detail_page.dart';
import '../ObbangChu/weather.js'; // fetchWeather 함수 있다고 가정

// 날씨 단순화 함수 (외부에 빼는 게 좋아요)
String simplifyWeather(String weatherMain) {
  switch (weatherMain) {
    case 'Clear':
      return '맑은';
    case 'Rain':
    case 'Drizzle':
    case 'Thunderstorm':
      return '비 오는';
    case 'Clouds':
    case 'Mist':
    case 'Haze':
    case 'Fog':
      return '흐린';
    case 'Snow':
      return '눈 오는';
    default:
      return '맑은';
  }
}

class ObbangChuScreen extends StatefulWidget {
  const ObbangChuScreen({super.key});

  @override
  State<ObbangChuScreen> createState() => _ObbangChuScreenState();
}

class _ObbangChuScreenState extends State<ObbangChuScreen> {
  String weather = "맑은";
  String breadName = "빵 고르는 중";
  String catText = "오늘의 빵 추천은~~??";
  String bakeryName = "고양이 베이커리";
  final String breadImageUrl = "lib/assets/images/breads/CreamBread.jpg";

  // 날씨에 따라 추천 빵과 말풍선 텍스트 뽑기
  Map<String, dynamic>  getBreadRecommendation(String weatherMain) {
    final weather = simplifyWeather(weatherMain);

    final Map<String, List<String>> breadsByWeather = {
      '맑은': ['크림빵', '소보루빵', '버터프레첼'],
      '비 오는': ['단팥빵', '모카번', '찹쌀도넛'],
      '흐린': ['마카롱', '식빵', '스콘'],
      'Default': ['크림빵'], // 기본 빵
    };

    final Map<String, List<String>> catMessagesByWeather = {
      '맑은': ['햇빛 쨍쨍한 날엔 역시 {bread}이지!', '맑은 날엔 달콤한 {bread} 어때?'],
      '비 오는': ['비 오는 날엔 따뜻한 {bread}이 최고야!', '촉촉한 날엔 {bread} 한 입!'],
      '흐린': ['흐린 날에는 부드러운 {bread}이 딱이지!', '포근한 날엔 {bread} 먹자!'],
      'Default': ['{bread}이 최고야!!'], // 기본 메시지
    };

    final breads = breadsByWeather[weather] ?? breadsByWeather['Default']!;
    final bread = breads[Random().nextInt(breads.length)];

    final messages = catMessagesByWeather[weather] ?? catMessagesByWeather['Default']!;
    final messageTemplate = messages[Random().nextInt(messages.length)];
    final message = messageTemplate.replaceAll('{bread}', bread);
    print("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ");
    return {
      'bread': bread,
      'text': message,
    };
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetWeather();

  }

  Future<void> fetchAndSetWeather() async {
    try {
      final fetchedWeather = await fetchWeather("Daejeon");
      final recommendation = getBreadRecommendation(fetchedWeather);
      setState(() {
        print("ㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎ");
        weather = simplifyWeather(fetchedWeather);
        breadName = recommendation['bread'];
        catText = recommendation['text'];
      });
    } catch (e) {
      setState(() {
        weather = "알 수 없음";
        breadName = "크림빵";
        catText = "오늘은 크림빵 어때?";
      });
    }
  }
  final Map<String, String> _bakeryMap = {
    "9114033" : "빵굽는 마을",
    "740243959" : "꾸드뱅베이커스하우스",
    "535720711" : "미미제과점",
    "1087674452" : "백조베이커리",
    "1055792304" : "파리바게뜨 대전용두선화점",
    "24710167" : "크리베리",
    "1181056420" : "사오 대전직영점"
  };
  late List<String> _bakeryIds = _bakeryMap.keys.toList();
  final Random _rng = Random();
  @override
  Widget build(BuildContext context) {
    if (weather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🐱 말풍선 + 꼬리
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "오늘은 $weather 날씨야!\n$catText",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 20,
                      child: CustomPaint(
                        painter: SpeechBubbleTailPainter(),
                        child: const SizedBox(width: 20, height: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'lib/assets/images/cats/cat_brown.png',
                  width: 140,
                  height: 140,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🥐 빵 카드
            GestureDetector(
              onTap: () {
                var randomId = _bakeryIds[_rng.nextInt(_bakeryIds.length)];
                breadName = _bakeryMap[randomId]!;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BakeryDetailPage(bakeryId: randomId),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          breadImageUrl,
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        breadName ?? '',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bakeryName,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.orange[100]!;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
