import 'package:flutter/material.dart'; //기본 내장 icons exist.

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key, //statelessWidget에서의 식별자
    required this.current, // 현재 위치해 있는 탭
    required this.onTap, // 탭 클릭시 callback
  });

  final int current; // final : 불변값 할당. tap을 누를 때마다 새로운 nav_bar 위젯이 생성됨.
  final ValueChanged<int> onTap;

  @override // StatelessWidget 안에 widget build 메소드가 정의되어 있음. 이 부모의 메소드를 내 방식으로 재정의 해서 가져다 쓰는 것
  Widget build(BuildContext context) { // buile 함수 : 외부에서 위젯의 위치 정보를 넘겨주면 그 위치에 return 안의 위젯 정보를 반환함.
    return SizedBox(
      height: 84,
      child: Stack( // stack : 여러 위젯을 겹쳐서 배치할 때 사용하는 위젯(bar와 지도 동그라미)
        clipBehavior: Clip.none, //  stack 영역 넘어가도 안잘리게 함
        children: [
          // 하단 바 배경
          Positioned.fill(
            child: Material(
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_icons.length, (i) {
                  final selected = i == current;
                  return _NavItem(
                    icon: _icons[i],
                    label: _labels[i],
                    selected: selected,
                    onTap: () => onTap(i),
                  );
                }),
              ),
            ),
          ),
          // 튀어오른 홈 버튼
          /*Positioned(
            top: -28,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: GestureDetector(
              onTap: () => onTap(0),
              child: CircleAvatar(
                radius: 28,
                backgroundColor:
                current == 0 ? Colors.black87 : Colors.grey.shade800,
                child: Icon(Icons.home,
                    color: Colors.white, size: 28),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white60; // selected 되었으면 흰색, 아니면 반투명 흰색
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

const _icons = [ // _icons에서 _는 접근 제한자. 외부 파일에서 import해도 접근할 수 없음.
  Icons.home,
  Icons.search,
  Icons.explore,
  Icons.person,
];

const _labels = ['Home', 'Search', 'Map', 'My'];
