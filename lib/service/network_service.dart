import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/state/user_state.dart';

// TODO [V2 - need to use connectivity_plus for network connectivity]
Future<bool> checkNetworkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com')
      .timeout(const Duration(seconds: 10));
 
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

class NetworkService {
  NetworkService._privateConstructor();
  static final NetworkService instance = NetworkService._privateConstructor();
  UserState? userState;

  void init(UserState userState) {
    this.userState = userState;
  }

  Future<dynamic> authRequest(String idToken, String email) async{
    String url = 'user/signup';

    final Map<String, dynamic> body = {
      'authType': 'google',
      'idToken': idToken,
      'email': email
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> verifyTokenRequest() async{
    String url = 'user/verify-token';

    return await _getRequest(url);
  }

  Future<dynamic> updateUserRecodeRequest(Map<String, String> data) async{
    String url = 'user/records';
    final Map<String, dynamic> body = data;

    return await _postRequest(url, body);
  }

  Future<dynamic> updateAdsRemainingCount(int count) async {
    String url = 'ads/remainingCount';
    final Map<String, dynamic> body = {
      "count": count
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> updateAdsHistory(String adsType, int remainingCount) async {
    String url = 'ads/history';
    final Map<String, dynamic> body = {
      'type': adsType,
      'remainingCount': remainingCount
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> updateAdsErrors(List<String> errors, int remainingCount) async {
    String url = 'ads/errors';
    final Map<String, dynamic> body = {
      'errors': errors,
      'remainingCount': remainingCount
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> sendErrorLogs(String log) async{
    String url = 'logs/error';

    final Map<String, dynamic> body = {
      'error': log
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> sendInfoLogs(String log) async{
    String url = 'logs/info';

    final Map<String, dynamic> body = {
      'info': log
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> sendWarningLogs(String log) async{
    String url = 'logs/warning';

    final Map<String, dynamic> body = {
      'warning': log
    };

    return await _postRequest(url, body);
  }

  Future<dynamic> _postRequest(String prefix, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.network.baseUrl}/$prefix');

    try {
      final response = await post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userState?.user?.token ?? ''}'
        },
        body: jsonEncode(body),
      );

      return response;
    } on TimeoutException {
      throw Exception(
        'The request timed out. Please try again.',
      );
    } on SocketException {
      throw Exception(
        'Unable to connect. Please check your internet connection and try again.',
      );
    } catch (e) {
      throw Exception(
        'Unable to complete the request. Please try again.',
      );
    }
  }

  Future<dynamic> _getRequest(String prefix) async {
    final url = Uri.parse('${AppConfig.network.baseUrl}/$prefix');

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userState?.user?.token ?? ''}'
        },
      );

      return response;
    } on TimeoutException {
      throw Exception(
        'The request timed out. Please try again.',
      );
    } on SocketException {
      throw Exception(
        'Unable to connect. Please check your internet connection and try again.',
      );
    } catch (e) {
      throw Exception(
        'Unable to complete the request. Please try again.',
      );
    }
  }
}