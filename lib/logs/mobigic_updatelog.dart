import 'dart:io';
import 'package:dio/dio.dart';

class MobigicHelper {
  static final Dio _dio = Dio();

  static Future<Response> uploadFile(File file, String jwtToken) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    return await _dio.post(
      "https://hrapi.mobigic.com/log-file",
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $jwtToken"}),
    );
  }
}
