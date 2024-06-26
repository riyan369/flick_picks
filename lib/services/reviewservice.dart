import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReviewService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";
  saveReview(String user) async {
    final response = await dio.post("${url}savereview", data: user);
    return response;
  }

  Future<dynamic> getReview(int userid) async {
    try {
      final response = await dio.post("${url}getReview", data: {"movieid": userid});

      // Assuming the response structure has a data field
      return response.data;
    } catch (error) {
      print('Error in getReview: $error');
      throw error; // Rethrow the error to handle it elsewhere if needed
    }
  }

}