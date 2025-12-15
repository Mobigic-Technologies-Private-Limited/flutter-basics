import 'package:dio/dio.dart';
import 'enum.dart';
class DioClient {
  final Dio _dio = Dio();

  Future<Response> multipartRequest(
    String url, {
    required FormData formData,
    RequestMethod method = RequestMethod.post,
    AuthToken authToken = AuthToken.multipartNone,
    bool isLogUpload = true,
  }) async {
    try {
      final headers = {
        'Content-Type': 'multipart/form-data',
      };

      final response = await _dio.request(
        url,
        data: formData,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers,
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
