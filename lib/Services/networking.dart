import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/project_exception.dart';

class NetworkHelper {
  Future<String> getHttp({required String url}) async {
    try {
      var response = await Dio().get(url).timeout(
            const Duration(milliseconds: 300),
            onTimeout: () => throw ProjectException('Timeout Error'),
          );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return '';
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        throw ProjectException('Http Error');
      }
    } finally {
      Dio().close(force: true);
    }
  }

  // Future<String> getHttp({required String url}) async {
  //   String data = '';
  //   try {
  //     http.Response response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       data = response.body;

  //       return data;
  //     } else {
  //       print(response.statusCode);

  //       return '';
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
}
