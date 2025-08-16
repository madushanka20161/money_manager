import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:money_manager_3/helper/config.dart';

// TODO [V2 - need to use connectivity_plus for network connectivity]
Future<bool> checkNetworkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

class NetworkService {
  NetworkService._privateConstructor();
  static final NetworkService instance = NetworkService._privateConstructor();

  Future<dynamic> authRequest(String idToken) async{
    String url = 'user';

    final Map<String, dynamic> body = {
      'authType': 'google',
      'idToken': idToken,
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> _postRequest(String prefix, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.network.baseUrl}/$prefix');

    try {
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      throw Exception('Oops! Something went wrong. Please try again.');
    }
  }
}