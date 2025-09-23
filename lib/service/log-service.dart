// import 'package:money_manager_3/service/network_service.dart';

class LogService {
  LogService._privateConstructor();
  static final LogService instance = LogService._privateConstructor();

  void error(String log) {
    // NetworkService.instance.sendErrorLogs(log);
  }

  void warning(String log) {
    // NetworkService.instance.sendWarningLogs(log);
  }

  void info(String log) {
    // NetworkService.instance.sendInfoLogs(log);
  }
}