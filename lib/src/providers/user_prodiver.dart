import 'dart:convert';

import 'package:http/http.dart' as http;

class UserProvider {
  final firebaseURL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  final String _apiToken = 'AIzaSyBNM9buH7hbJZ-GnDQfMG-g_-2Mi7ZdoCk';

  Future newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.parse('$firebaseURL$_apiToken');

    final response = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);

    if (decodeResponse.containsKey('idToken')) {
      return {'ok': true, 'token': decodeResponse['idToken']};
    }

    return {'ok': false, 'message': decodeResponse['error']['message']};
  }
}
