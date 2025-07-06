import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color white = Colors.white;
final Color ivory = Color(0xFFECE6CC);
const Color darkGrey = Color(0xFF555555);

class PhotoAlbumPage extends StatefulWidget {
  @override
  State<PhotoAlbumPage> createState() => _PhotoAlbumPageState();
}

class _PhotoAlbumPageState extends State<PhotoAlbumPage> {
  int current = 0;

  final List<Map<String, dynamic>> reviews = [
    {
      'profileImage': 'lib/assets/images/cats/cat_gray.png',
      'username': '빵덕후',
      'rating': 5,
      'comment': '여기 빵 정말 맛있어요!',
    },
    {
      'profileImage': 'lib/assets/images/cats/cat_brown.png',
      'username': '빵순이',
      'rating': 4,
      'comment': '분위기도 좋고 재방문 의사 있음',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('빵냥이의 빵로그'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '빵냥이의 빵로그',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) {
                  final imagePath = 'lib/assets/album/$index.png';
                  final review = index < reviews.length ? reviews[index] : null;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (review != null) {
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
                                      child: Image.asset(imagePath, fit: BoxFit.cover),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.asset(
                                            review['profileImage'],
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
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
                                                    review['username'],
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
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('닫기'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
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
      bottomNavigationBar: BottomNavBar(
        current: current,
        onTap: (index) => setState(() => current = index),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 70.0,
      duration: const Duration(milliseconds: 400),
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < navBtn.length; i++)
            GestureDetector(
              onTap: () => onTap(i),
              child: SizedBox(
                width: 75.0,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedContainer(
                        height: current == i ? 60.0 : 0.0,
                        width: current == i ? 50.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: current == i
                            ? CustomPaint(painter: ButtonNotch())
                            : const SizedBox(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        navBtn[i].imagePath,
                        color: current == i ? ivory : darkGrey,
                        width:24,
                        height:24,
                        fit:BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ButtonNotch extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var dotPoint = Offset(size.width / 2, 2);

    var paint_1 = Paint()
      ..color = ivory
      ..style = PaintingStyle.fill;
    var paint_2 = Paint()
      ..color = white
      ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(7.5, 0, 12, 5);
    path.quadraticBezierTo(size.width / 2, size.height / 3, size.width - 12, 5);
    path.quadraticBezierTo(size.width - 7.5, 0, size.width, 0);
    path.close();
    canvas.drawPath(path, paint_1);
    canvas.drawCircle(dotPoint, 5, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Model {
  final int id;
  final String imagePath;
  final String name;

  Model({required this.id, required this.imagePath, required this.name});
}

List<Model> navBtn = [
  Model(id: 0, imagePath: 'lib/assets/images/icon/homeIcon.svg', name: 'Home'),
  Model(id: 1, imagePath: 'lib/assets/images/icon/rankingIcon.svg', name: 'Ranking'),
  Model(id: 2, imagePath: 'lib/assets/images/icon/mapIcon.svg', name: 'Map'),
  Model(id: 3, imagePath: 'lib/assets/images/icon/myIcon.svg', name: 'My'),
];
