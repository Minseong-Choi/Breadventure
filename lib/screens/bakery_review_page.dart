import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 리뷰 작성 화면 (일회성, 목업용)
class BakeryReviewPage extends StatefulWidget {
  /// 별점(rating)과 후기(reviewText)를 부모로 전달
  final void Function(int rating, String reviewText) onSubmit;

  const BakeryReviewPage({super.key, required this.onSubmit});

  @override
  State<BakeryReviewPage> createState() => _BakeryReviewPageState();
}

class _BakeryReviewPageState extends State<BakeryReviewPage> {
  File? _selectedImage;
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🥐 빵집 리뷰 작성')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 별점 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.amber : Colors.grey,
                    size: 36,
                  ),
                  onPressed: () => setState(() {
                    _rating = index + 1;
                  }),
                );
              }),
            ),
            const SizedBox(height: 24),

            // 이미지 선택 (선택 사항)
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('사진 추가'),
                ),
                const SizedBox(width: 16),
                if (_selectedImage != null)
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 후기 입력
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '후기를 입력해주세요...',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            // 등록 버튼
            ElevatedButton(
              onPressed: () {
                // 부모 콜백 전달
                widget.onSubmit(_rating, _reviewController.text);
                Navigator.pop(context);
              },
              child: const Text('리뷰 등록'),
            ),
          ],
        ),
      ),
    );
  }
}