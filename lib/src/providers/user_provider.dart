import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_form/src/preferences/user_prefs.dart';

class UserProvider {
  final firebaseURL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  final String _apiToken = 'AIzaSyBNM9buH7hbJZ-GnDQfMG-g_-2Mi7ZdoCk';
  final _prefs = UserPrefs();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.parse('${firebaseURL}signInWithPassword?key=$_apiToken');

    final response = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);
    print(decodeResponse);
    if (decodeResponse.containsKey('idToken')) {
      final token = decodeResponse['idToken'];
      _prefs.token = token;
      return {'ok': true, 'token': token};
    }

    return {'ok': false, 'message': decodeResponse['error']['message']};
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.parse('${firebaseURL}signUp?key=$_apiToken');

    final response = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);
    print(decodeResponse);
    if (decodeResponse.containsKey('idToken')) {
      return {'ok': true, 'token': decodeResponse['idToken']};
    }

    return {'ok': false, 'message': decodeResponse['error']['message']};
  }
}
