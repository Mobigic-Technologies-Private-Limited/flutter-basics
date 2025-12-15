import 'dart:io';
import 'package:dio/dio.dart';

class MobigicHelper {
   static final Dio _dio = Dio();

  static Future<Response> uploadFile(File file) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    return await _dio.post(
      "https://hrapi-dev.hr360app.com/v1/log-file",
      data: formData,
    );
  }
}
