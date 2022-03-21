import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:academiaapp/common/providers/routes_provider.dart';


class SignUpProvider{
  signUp(String email, String password, name) async {
    http.Response response = await http.post(
      Uri.parse(Routes().signUp()),
      body: json.encode(
        {
          "displayName": name,
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
    return response;
    print(response.body);
  }
}


class LoginService {
  login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(Routes().signIn()),
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
    // print(response.body);
    return response;
  }
}