import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/dto/ads_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/default_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/dto/user_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/exception/api-exception.dart';
import 'package:money_manager_3/exception/general-exception.dart';
import 'package:money_manager_3/helper/constant.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/ads_service.dart';
import 'dart:convert';
import 'package:money_manager_3/service/database_service.dart';
import 'package:money_manager_3/service/log-service.dart';
import 'package:money_manager_3/service/network_service.dart';
import 'package:money_manager_3/service/notification_service.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';

class AuthService {
  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();
  late GoogleSignIn _googleSignIn;
  late AppState _appState;
  late UserState _userState;

  Future<void> init(AppState appState, UserState userState) async {
    _googleSignIn = GoogleSignIn.instance;
  await _googleSignIn.initialize(
    serverClientId:
        '552343521160-b3fcde5tjqossm80b6qa6oat1e9bfqaa.apps.googleusercontent.com',
  );
    _appState = appState;
    _userState = userState;
  }

  Future<void> checkAuth() async {
    String? storeUser = await DatabaseService.instance.getData('user');

    if (storeUser == null) {
      signOut();

      return;
    } else {
      var userDecode = jsonDecode(storeUser);
      UserDTO userDTO = UserDTO(
        id: userDecode['id'],
        email: userDecode['email'],
        name: userDecode['name'],
        photoUrl: userDecode['photoUrl'],
        token: userDecode['token']
      );

      _userState.setUser(userDTO);

      await sendVerifyTokenRequest(jsonDecode(storeUser)['token']);

      return;
    }
  }

  Future<void> onAuthSuccess() async {
    _appState.setIsSignIn(true);
    _appState.setIsLoading(false);
    DatabaseService.instance.setUserId(_userState.user!.id);

    await loadStoredData();
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      DatabaseService.instance.deleteData('user');

      _appState.setIsSignIn(false);
      _appState.setIsLoading(false);
    } catch (error) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  Future<void> sendVerifyTokenRequest(String token) async {
    try {
      final response = await NetworkService.instance.verifyTokenRequest();
      final responseBody = jsonDecode(response.body);

      if (responseBody['statusCode'] == 200) {
        if (responseBody['lastUpdatedTime'] != null) {
          _userState.setLastUpdatedTime(
              DateTime.parse(responseBody['lastUpdatedTime'] as String));
        }

        _userState.setAds(AdsDTO(
            remaingCount: responseBody['ads']['remaingCount'],
            isAdsEnable: responseBody['ads']['isAdsEnable'],
            isAdsReqEnable: responseBody['ads']['isAdsReqEnable']));

        _userState.setJWTToken(responseBody['token'] as String);

        AdsService.instance.prepareAds();

        return;
      } else {
        final String errorMessage = responseBody['message'].toString();

        LogService.instance.error(errorMessage);

        if (errorMessage == Constant.tokenVerificationFailExpired) {
          throw ApiException(
            code: responseBody['message'],
            message: 'Your session has expired. Please sign in again.'
          );
        } else if (errorMessage == Constant.tokenVerificationFailInvalid) {
          throw ApiException(
            code: responseBody['message'],
            message: 'Your session is no longer valid. Please sign in again.'
          );
        } else {
          throw ApiException(
            code: responseBody['message'],
            message: 'Something went wrong. Please try again.'
          );
        }

        // TODO [need to delet saved used data]
      }
    } on ApiException {
      rethrow;
    } catch (error) {
      
      LogService.instance.error(error.toString());

      throw GeneralException(error.toString());
    }
  }

  Future<void> sendAuthRequest(String idToken, GoogleSignInAccount user, bool isSignInByUser) async {
    final String displayName = user.displayName ?? '';
    final String email = user.email;

    try {
      _appState.setIsLoading(true);
      final response = await NetworkService.instance.authRequest(idToken, email);
      final responseBody = jsonDecode(response.body);
      _appState.setIsLoading(false);

      UserDTO userDTO = UserDTO(
        id: user.id,
        email: user.email,
        name: user.displayName ?? '--',
        photoUrl: user.photoUrl ?? '',
        token: responseBody['token']
      );

      _userState.setUser(userDTO);

      String jsonString = jsonEncode(userDTO);
      DatabaseService.instance.saveData('user', jsonString);

      if (responseBody['statusCode'] == 200) {
        if (responseBody['isNewUser']) {
          _appState.setIsFirstLogin(responseBody['isNewUser']);

          NotificationService.instance.showNotification('Welcome, $displayName',
              'We’re excited to have you on board. Explore and enjoy your journey with us!');
        } else {
          if (isSignInByUser) {
            NotificationService.instance.showNotification(
                'Welcome back,  $displayName',
                'Great to see you again. Let’s continue where you left off.');
          }
        }

        if (responseBody['lastUpdatedTime'] != null) {
          _userState.setLastUpdatedTime(
              DateTime.parse(responseBody['lastUpdatedTime']));
        }

        _userState.setAds(AdsDTO(
            remaingCount: responseBody['ads']['remaingCount'],
            isAdsEnable: responseBody['ads']['isAdsEnable'],
            isAdsReqEnable: responseBody['ads']['isAdsReqEnable']));

        AdsService.instance.prepareAds();

        return;
      } else {
        LogService.instance.error(responseBody['message'].toString());

        if (responseBody['message'].toString() == 'TOKEN_VERIFICATION_FAIL') {
          throw GeneralException(
              'Authentication with Google failed. Please try again.');
        } else {
          throw GeneralException(responseBody['message'].toString());
          // throw GeneralException(
          //     'Sign-in with Google didn’t work. Please try again.');
        }
      }
    } catch (e) {
      _appState.setIsLoading(false);
      
      LogService.instance.error(e.toString());

      throw Exception(e);
    }
  }

  Future<void> signIn() async {
    GoogleSignInAccount? user;

    try {
      user = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = user.authentication;
      final String? idToken = googleAuth.idToken;

      await sendAuthRequest(idToken!, user, true);
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }

    onAuthSuccess();
  }

  Future<void> loadStoredData() async {
    _appState.clearAll();

    String? defaultString = DatabaseService.instance.getData('default');
    late String defaultTimePeriod;
    late String defaultCurrency;
    late String defaultDecimalPlace;
    late String defaultNumberSeperationStyle;

    if (defaultString != null) {
      Map<String, dynamic> defaultObj = jsonDecode(defaultString);
      defaultObj = _unBindVersion(defaultObj);

      defaultTimePeriod = defaultObj['defaultTimePeriod'];
      defaultCurrency = defaultObj['defaultCurrency'];
      defaultDecimalPlace = defaultObj['defaultDecimalPlace'].toString();
      defaultNumberSeperationStyle = defaultObj['defaultNumberSeperationStyle'];
    } else {
      defaultTimePeriod = TimePeriod.month.displayName;
      defaultCurrency = 'USD';
      defaultDecimalPlace = '2';
      defaultNumberSeperationStyle = NumberSelectionStyleType.us.toString();
    }

    DefaultDto defaultDto = DefaultDto(
        defaultTimePeriod: defaultTimePeriod,
        defaultCurrency: defaultCurrency,
        defaultDecimalPlace: int.parse(defaultDecimalPlace),
        defaultNumberSeperationStyle: defaultNumberSeperationStyle);

    UserStateService.instance.init(defaultDto);
    SharedService.instance.updateDefaultTimePeriod(defaultTimePeriod);
    SharedService.instance.updateDefaultConfig();
    // TODO: Need to send api request

    // String? categoriesString = null;
    String? categoriesString = DatabaseService.instance.getData('category');
    String? accountsString = DatabaseService.instance.getData('account');
    String? transactionsString =
        DatabaseService.instance.getData('transaction');
    String? accountTransactionsString =
        DatabaseService.instance.getData('account-trnsaction');

    _updateUserRecode({
      'default': defaultString ?? '',
      'categories': categoriesString ?? '',
      'accounts': accountsString ?? '',
      'transactions': transactionsString ?? '',
      'accountTransactions': accountTransactionsString ?? ''
    });

    if (categoriesString != null) {
      Map<String, dynamic> categoriesObj = jsonDecode(categoriesString);
      Map<String, dynamic> categories = {};
      categoriesObj = _unBindVersionWithVersion(categoriesObj);

      if (categoriesObj['version'] == 0) {
        int start = 0;
        categories = jsonDecode(categoriesObj['data']);
        categories.forEach((id, category) {
          category['index'] = start;
          start += 1;

          CategoryDTO categoryDto = CategoryDTO.fromJson(category);
          _appState.addCategory(categoryDto.id, categoryDto);
        });
      } else {
        categories = jsonDecode(categoriesObj['data']);

        categories.forEach((id, category) {
          CategoryDTO categoryDto = CategoryDTO.fromJson(category);
          _appState.addCategory(categoryDto.id, categoryDto);
        });
      }
    } else {
      List<String> categories = defaultCategories;

      categories.forEach((data) {
        List<String> parts = data.split('|');
        SharedService.instance.createCategory(
            parts[0],
            iconMap[parts[1]]!,
            colorMap[parts[2]]!,
            parts[3] == 'income'
                ? TransactionType.income
                : TransactionType.expenses,
            CategoryLimitDTO(type: CategoryLimitType.value, limit: 0),
            int.tryParse(parts[4])!);
      });
    }

    if (accountsString != null) {
      Map<String, dynamic> accounts = jsonDecode(accountsString);
      accounts = _unBindVersion(accounts);

      accounts.forEach((id, account) {
        AccountDto accountDto = AccountDto.fromJson(account);
        _appState.addAccount(accountDto.id, accountDto);
      });
    }

    if (transactionsString != null) {
      Map<String, dynamic> transations = jsonDecode(transactionsString);
      transations = _unBindVersion(transations);

      transations.forEach((id, transaction) {
        transaction['account'] = _appState.accounts[transaction['account']];
        transaction['category'] = _appState.categories[transaction['category']];
        TransactionDto transactionDto = TransactionDto.fromJson(transaction);
        _appState.addTransaction(transactionDto.id, transactionDto);
      });
    }

    if (accountTransactionsString != null) {
      Map<String, dynamic> accountTransactions =
          jsonDecode(accountTransactionsString);
      accountTransactions = _unBindVersion(accountTransactions);

      accountTransactions.forEach((id, accountTransaction) {
        accountTransaction['fromAccount'] =
            _appState.accounts[accountTransaction['fromAccount']];
        accountTransaction['toAccount'] =
            _appState.accounts[accountTransaction['toAccount']];
        AccountTransactionDTO accountTransactionDto =
            AccountTransactionDTO.fromJson(accountTransaction);
        _appState.addAccountTrnsaction(
            accountTransactionDto.id, accountTransactionDto);
      });
    }
  }

  void _updateUserRecode(Map<String, String> data) async {
    if (await checkNetworkConnection()) {
      final lastUpdatedTime = _userState.lastUpdatedTime;
      final DateTime today = DateTime.now();

      if ((lastUpdatedTime == null) || (lastUpdatedTime.toLocal().toString().split(" ")[0] != today.toString().split(" ")[0])) {
        NetworkService.instance.updateUserRecodeRequest(data);
      }
    }
  }

  Map<String, dynamic> _unBindVersionWithVersion(Map<String, dynamic> data) {
    if (data['version'] == null) {
      return {'version': 0, 'data': jsonEncode(data)};
    } else {
      return data;
    }
  }

  Map<String, dynamic> _unBindVersion(Map<String, dynamic> data) {
    if (data['version'] == null) {
      return data;
    } else {
      return jsonDecode(data['data']);
    }
  }
}
