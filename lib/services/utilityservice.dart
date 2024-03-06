import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UtilityService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";

  updateEmail(String email, String userid) async {
    final response = await dio
        .post("${url}updateEmail", data: {"email": email, "userid": userid});
    return response;
  }

  updatePhoneNumber(int phone, String userid) async {
    final response = await dio.post("${url}updatePhoneNumber",
        data: {"phone": phone, "userid": userid});
    return response;
  }

  updatePassword(String password, String userid) async {
    final response = await dio.post("${url}updatePassword",
        data: {"password": password, "userid": userid});
    return response;
  }

  findUserByEmail(String email) async {
    final response =
    await dio.post("${url}findUserByEmail", data: {"email": email});
    return response;
  }

  //complaint

  addComplaint(String details) async {
    final response = await dio.post("${url}addComplaint", data: details);
    return response;
  }

  getAllComplaint() async {
    final response = await dio.post("${url}getAllComplaint");
    return response;
  }

  getComplaintByUserid(String userid) async {
    final response =
    await dio.post("${url}getComplaintByUserid", data: {"userid": userid});
    return response;
  }

  getComplaintById(String complaintid) async {
    final response = await dio
        .post("${url}getComplaintById", data: {"complaintid": complaintid});
    return response;
  }

  addReplyToComplaint(String details) async {
    final response = await dio.post("${url}addReplyToComplaint", data: details);
    return response;
  }
}