import 'dart:io';
import 'package:flutter_basics/logs/upload_result.dart';
import 'package:http/http.dart' as http;
class MobigicHelper {
  Future<UploadResult> uploadLogFileHttp(File file, String jwt) async {
    try {
      final uri = Uri.parse("https://hrapi.mobigic.com/log-file");

      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $jwt',
        'Accept': 'application/json',
      });

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        return UploadResult(
          success: true,
          statusCode: 200,
          message: responseBody,
        );
      } else {
        return UploadResult(
          success: false,
          statusCode: streamedResponse.statusCode,
          message: responseBody,
        );
      }
    } catch (e) {
      return UploadResult(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }
}
