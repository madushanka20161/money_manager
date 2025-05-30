import 'dart:io';

// TODO [V2 - need to use connectivity_plus for network connectivity]
Future<bool> checkNetworkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}
