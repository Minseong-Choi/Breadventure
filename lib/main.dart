import 'package:flutter/material.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/ObbangChu/ObbangChu_screen.dart';
import 'screens/best/best_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/my/my_screen.dart';
import 'package:breadventure/utils/review_storage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ReviewStorage.resetReviews();
  runApp(const BreadApp());
}



class BreadApp extends StatelessWidget {
  const BreadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breadventure',
      debugShowCheckedModeBanner: false, // 앱 화면 우상단의 debug 배너를 숨김
      theme: ThemeData(
        colorSchemeSeed: const Color(0xffFFB347),
        scaffoldBackgroundColor: const Color(0xFFFCEAD9),
        useMaterial3: true,
      ),
      home: const _RootTabView(), // 앱 실행시 처음 보여줄 화면
    );
  }
}

class _RootTabView extends StatefulWidget {
  const _RootTabView(); //생성자. home으로 불러질 때 사용됨

  @override
  State<_RootTabView> createState() => _RootTabViewState(); //state object 생성. 동작은 RootTabViewState에서 구현됨.
}

class _RootTabViewState extends State<_RootTabView> {
  int _current = 0;

  final _pages = [
    ObbangChuScreen(),
    BestScreen(),
    MapScreen(),
    MyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Widget body = (_current == 2)
      ? MapScreen(key: UniqueKey()) : _pages[_current];;

    return Scaffold(
      body: _current == 2 ? body : IndexedStack(index: _current, children: _pages),
      bottomNavigationBar: BottomNavBar(
        current: _current,
        onTap: (i) => setState(() => _current = i),
      ),
    );
  }
}
