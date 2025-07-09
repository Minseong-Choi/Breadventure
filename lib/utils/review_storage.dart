import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/comment.dart';

/// 로컬 장치에 리뷰를 저장/불러오는 유틸리티
class ReviewStorage {

  /// documents 디렉토리 내 reviews.json 파일 경로를 가져오거나 생성합니다.
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reviews.json');
    if (!await file.exists()) {
      // 파일이 없으면 빈 리스트 형태로 생성
      await file.writeAsString(json.encode([]), flush: true);
    } else {
      print('reviews.json 이미 존재함');
    }
    return file;
  }
  static Future<void> resetReviews() async {
    final file = await _getFile();
    await file.writeAsString(json.encode([]), flush: true);
    print('reviews.json 초기화됨');
  }
  /// 새 리뷰 엔트리를 JSON 파일 맨 앞에 추가합니다.
  static Future<void> insertAtFront(Map<String, dynamic> entry) async {
    final file = await _getFile();
    final raw  = await file.readAsString();
    final list = json.decode(raw) as List<dynamic>;
    list.insert(0, entry);
    await file.writeAsString(json.encode(list), flush: true);
    print('새 리뷰 저장: \$entry');
  }

  /// 저장된 reviews.json 파일을 불러와 Comment 객체 리스트로 반환합니다.
  static Future<List<Comment>> loadReviews() async {
    final file = await _getFile();
    final raw  = await file.readAsString();
    final data = json.decode(raw) as List<dynamic>;
    return data
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}