import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/authservice.dart';
import '../services/utilityservice.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  bool isloading = false;
  dynamic _data;
  AuthService _authService = AuthService();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _newpassword = TextEditingController();

  UtilityService _utilityService = UtilityService();
  String? password;

  bool istrue = false;

  getProfile() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res = await _authService.getUser(userid!);
      if (mounted) {
        setState(() {
          _data = res.data;
          _email.text = res.data["email"];
          _phone.text = res.data["phone"].toString();
          password = res.data["password"];
          isloading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  updateEmail() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res =
      await _utilityService.updateEmail(_email.text, userid!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email Updated Successfully"),
        duration: Duration(milliseconds: 3000),
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  updatePhone() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res = await _utilityService.updatePhoneNumber(
          int.parse(_phone.text.toString()), userid!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Phone Number Updated Successfully"),
        duration: Duration(milliseconds: 3000),
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  checkPassword() {
    if (password == _password.text) {
      setState(() {
        istrue = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Password Not Coorect"),
              content: Text("Current password is not correct"),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  changePassword() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res =
      await _utilityService.updatePassword(_newpassword.text, userid!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password Updated Successfully"),
        duration: Duration(milliseconds: 3000),
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Profile")),
        body: isloading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              _data["name"],
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              _data["email"],
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.yellow,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(label: Text("Email")),
              keyboardType: TextInputType.emailAddress,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Please enter email";
                }
                return null;
              },
            ),
            Container(
                child: ElevatedButton(
                    onPressed: () {
                      updateEmail();
                    },
                    child: Text("Update Email"))),
            SizedBox(
              height: 10,
            ),
            Text(
              _data["phone"].toString(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.yellow,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _phone,
              decoration: InputDecoration(label: Text("Phone")),
              keyboardType: TextInputType.phone,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Please enter phone number";
                }
                return null;
              },
            ),
            Container(
                child: ElevatedButton(
                    onPressed: () {
                      updatePhone();
                    },
                    child: Text("Update Phone"))),
            SizedBox(
              height: 10,
            ),
            Text(
              "Change Password",
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              controller: _password,
              decoration:
              InputDecoration(label: Text("Current Password")),
              keyboardType: TextInputType.visiblePassword,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Please enter password";
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  checkPassword();
                },
                child: Text("Submit")),
            SizedBox(
              height: 10,
            ),
            if (istrue) ...[
              Text(
                "New Password",
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _newpassword,
                decoration: InputDecoration(label: Text("New Password")),
                keyboardType: TextInputType.visiblePassword,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    changePassword();
                  },
                  child: Text("Password Changes"))
            ]
          ],
        ));
  }
}