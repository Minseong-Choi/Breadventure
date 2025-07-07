import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BakeryReviewPage extends StatefulWidget {
  const BakeryReviewPage({super.key});

  @override
  State<BakeryReviewPage> createState() => _BakeryReviewPageState();
}

class _BakeryReviewPageState extends State<BakeryReviewPage> {
  File? _selectedImage;
  int _rating = 0; // 현재 선택한 별점
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
      appBar: AppBar(title: const Text('🥐 빵집 리뷰')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 별점
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < _rating ? Colors.amber : Colors.grey,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1; // 인덱스는 0부터 시작하니 +1
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 24),
              // 이미지 선택 버튼
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text('사진 추가'),
                  ),
                  const SizedBox(width: 16),
                  // 선택한 이미지 미리보기
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '후기를 작성해주세요...',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 리뷰 등록 로직 작성
                },
                child: const Text('리뷰 등록'),
              ),
            ],
          ),
        ),
      )

    );
  }
}
