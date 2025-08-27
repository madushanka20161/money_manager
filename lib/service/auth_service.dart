import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/dto/ads_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/default_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/dto/user_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/exception/general-exception.dart';
import 'package:money_manager_3/helper/index.dart';
import 'dart:convert';
import 'package:money_manager_3/service/database_service.dart';
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
    _googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            '581198894251-cc8a2924047shafk33gt5qe14u7bh22g.apps.googleusercontent.com');
    _appState = appState;
    _userState = userState;
  }

  Future<void> checkAuth() async {
    String? storeUser = await DatabaseService.instance.getData('user');

    if (storeUser != null) {
      if (await checkNetworkConnection()) {
        GoogleSignInAccount? user = await _googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth =
            await user?.authentication;
        final String? idToken = googleAuth?.idToken;

        // for (int i = 0; i < idToken!.length; i += 400) {
        //   print(idToken.substring(i, i + 400 > idToken.length ? idToken.length : i + 400));
        // }

        try {
          await sendAuthRequest(idToken!, user!.displayName ?? '', user.email, false);
        } catch (error) {
          throw GeneralException(error.toString().replaceAll('Exception: ', ''));
        }
      }

      var userDecode = jsonDecode(storeUser);
      UserDTO userDTO = UserDTO(
        id: userDecode['id'],
        email: userDecode['email'],
        name: userDecode['name'],
        photoUrl: userDecode['photoUrl'],
      );

      _userState.setUser(userDTO);
      _appState.setIsSignIn(true);
      DatabaseService.instance.setUserId(userDTO.id);

      await loadStoredData();
    } else {
      await signOut();
      _appState.setIsSignIn(false);
    }

    _appState.setIsLoading(false);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      DatabaseService.instance.deleteData('user');

      _appState.setIsSignIn(false);
    } catch (error) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  Future<void> sendAuthRequest(
    String idToken, String displayName, String email, bool isSignInByUser) async {
    
    try {
      final response = await NetworkService.instance.authRequest(idToken, email);
      final responseBody = jsonDecode(response.body);

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

        _userState.setJWTToken(responseBody['token']);

        return;
      } else {
        if (responseBody['message'].toString() == 'TOKEN_VERIFICATION_FAIL') {
          throw GeneralException(
              'Authentication with Google failed. Please try again.');
        } else {
          throw GeneralException(
              'Authentication with Google failed. Please try again.');
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signIn() async {
    GoogleSignInAccount? user;

    try {
      user = await _googleSignIn.signIn();

      if (user == null) {
        throw Exception("Something went wrong. Please try again.");
      }

      final GoogleSignInAuthentication googleAuth = await user.authentication;
      final String? idToken = googleAuth.idToken;

      await sendAuthRequest(idToken!, user.displayName ?? '', user.email, true);
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }

    UserDTO userDTO = UserDTO(
      id: user.id,
      email: user.email,
      name: user.displayName ?? '--',
      photoUrl: user.photoUrl ?? '',
    );

    _userState.setUser(userDTO);
    String jsonString = jsonEncode(userDTO);
    DatabaseService.instance.saveData('user', jsonString);
    DatabaseService.instance.setUserId(userDTO.id);

    await loadStoredData();
    _appState.setIsSignIn(true);
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
      var lastUpdatedTime = _userState.lastUpdatedTime;

      if ((lastUpdatedTime == null) || (true)) {
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
