import 'package:flutter/material.dart';
import '../../widgets/bakery_detail_content.dart';

class RestaurantBottomSheet extends StatefulWidget {
  const RestaurantBottomSheet({super.key});

  @override
  State<RestaurantBottomSheet> createState() => _RestaurantBottomSheetState();
}

class _RestaurantBottomSheetState extends State<RestaurantBottomSheet> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // ⭐️ 핸들바 추가
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // 🍞 빵집 상세 내용
                BakeryDetailContent(
                  isLiked: isLiked,
                  onLikeToggle: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
