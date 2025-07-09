import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkService {
  static Future<bool> uploadReview({
    required int rating,
    required String comment,
    required File photoFile,
  }) async {
    final uri = Uri.parse('https://your.server.com/api/reviews');
    final request = http.MultipartRequest('POST', uri)
      ..fields['rating'] = rating.toString()
      ..fields['comment'] = comment
      ..files.add(await http.MultipartFile.fromPath(
        'photo', photoFile.path,
      ));
    final resp = await request.send();
    return resp.statusCode == 200;
  }
}
