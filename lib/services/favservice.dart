import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";


  saveFav(String fav, String movie) async {
    final response = await dio.post("${url}savefav", data: {"fav": fav,"movie":movie});
    return response;
  }


  Future<dynamic> getFav(String userid) async {
    try {
      final response = await dio.post("${url}getFav", data: {"userId": userid});

      // Assuming the response structure has a data field
      return response.data;
    } catch (error) {
      print('Error in getReview: $error');
      throw error; // Rethrow the error to handle it elsewhere if needed
    }
  }

}