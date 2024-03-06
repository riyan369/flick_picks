import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";
  registerUser(String user) async {
    final response = await dio.post("${url}register", data: user);
    return response;
  }

  loginUser(String user) async {
    final response = await dio.post("${url}login", data: user);
    if (response.statusCode == 200) {
      await storage.write(key: "token", value: response.data["token"]);
    }
    return response;
  }

  getUser(String userid) async {
    final response = await dio.post("${url}getuser", data: {"userid": userid});
    return response;
  }
}