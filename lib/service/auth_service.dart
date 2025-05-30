import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/dto/user_dto.dart';
import 'package:money_manager_3/helper/index.dart';
import 'dart:convert';
import 'package:money_manager_3/service/database_service.dart';
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
    _googleSignIn = GoogleSignIn();
    _appState = appState;
    _userState = userState;
    // // throw Exception("Something went wrong:");
    // final signInUser = await _googleSignIn.signInSilently();
    // print('33333333333333333333333333333');
    // print(storeUser);
    // print(signInUser);
    // print('444444444444444444444444444');
    // throw Exception("Something went wrong:");
    // if (storeUser == null && signInUser != null) {
    //   signOut();
    // }
    // signIn();
  }

  Future<void> checkAuth() async {
    String? storeUser = await DatabaseService.instance.getData('user');

    if (storeUser != null) {
      var userDecode = jsonDecode(storeUser);
      UserDTO userDTO = UserDTO(
        id: userDecode['id'],
        email: userDecode['email'],
        name: userDecode['name'],
        photoUrl: userDecode['photoUrl'],
      );

      _userState.setUser(userDTO);
      _appState.setIsSignIn(true);
    } else {
      _appState.setIsSignIn(false);
    }

    _appState.setIsLoading(false);

    await loadStoredData();
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      DatabaseService.instance.deleteData('user');

      _appState.setIsSignIn(false);
      // TODO: [Need to clear storage (data, accounts)]
    } catch (error) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  Future<void> signIn() async {
    GoogleSignInAccount? user;

    try {
      user = await _googleSignIn.signIn();
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }

    if (user != null) {
      UserDTO userDTO = UserDTO(
        id: user.id,
        email: user.email,
        name: user.displayName ?? '--',
        photoUrl: user.photoUrl ?? '',
      );
      
      _userState.setUser(userDTO);

      String jsonString = jsonEncode(userDTO);
      DatabaseService.instance.saveData('user', jsonString);
      
      _appState.setIsSignIn(true);
    } else {
      // TODO [need to handle this part]
      throw Exception("Something went wrong. Please try again.");
    }
  }

  Future<void> loadStoredData() async {
    String defaultTimePeriod = await DatabaseService.instance.getData('defaultTimePeriod') ?? 'month';
    List<DateTime> dateRange = getDateRange(defaultTimePeriod, null);
    UserStateService.instance.init(defaultTimePeriod);
    _userState.setDefaultTimePeriod(defaultTimePeriod);
    _appState.setDateRange(dateRange[0], dateRange[1]);
    // TODO: Need to send api request

    String? categoriesString = DatabaseService.instance.getData('category');
    String? accountsString = DatabaseService.instance.getData('account');
    String? transactionsString = DatabaseService.instance.getData('transaction');
    String? accountTransactionsString = DatabaseService.instance.getData('account-trnsaction');

    if (categoriesString != null) {
      Map<String, dynamic> categories = jsonDecode(categoriesString);
      categories.forEach((id, category) {
        CategoryDTO categoryDto = CategoryDTO.fromJson(category);
        _appState.addCategory(categoryDto.id, categoryDto);
      });
    }
      
    if (accountsString != null) {
      Map<String, dynamic> accounts = jsonDecode(accountsString);
      accounts.forEach((id, account) {
        AccountDto accountDto = AccountDto.fromJson(account);
        _appState.addAccount(accountDto.id, accountDto);
      });
    }

    if (transactionsString != null) {
      Map<String, dynamic> transations = jsonDecode(transactionsString);
      transations.forEach((id, transaction) {
        transaction['account'] = _appState.accounts[transaction['account']];
        transaction['category'] = _appState.categories[transaction['category']];
        TransactionDto transactionDto = TransactionDto.fromJson(transaction);
        _appState.addTransaction(transactionDto.id, transactionDto);
      });
    }
      
    if (accountTransactionsString != null) {
      Map<String, dynamic> accountTransactions = jsonDecode(accountTransactionsString);
      accountTransactions.forEach((id, accountTransaction) {
        accountTransaction['fromAccount'] = _appState.accounts[accountTransaction['fromAccount']];
        accountTransaction['toAccount'] = _appState.accounts[accountTransaction['toAccount']];
        AccountTransactionDTO accountTransactionDto = AccountTransactionDTO.fromJson(accountTransaction);
        _appState.addAccountTrnsaction(accountTransactionDto.id, accountTransactionDto);
      });
    }
  }
}