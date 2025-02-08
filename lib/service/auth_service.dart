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
    String? storeUser = await DatabaseService.instance.getData('user');
    final signInUser = await _googleSignIn.signInSilently();

    if (storeUser == null && signInUser != null) {
      signOut();
    }
    
    signIn();
    // signOut();
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      DatabaseService.instance.deleteData('user');
      // TODO: Need to clear storage (data, accounts)
      print("User signed out");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  Future<void> signIn() async {
    print('11111-------22222');
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    print('11111-------22222');
    if (user != null) {
      print('111111111111111111111111111111111111111111');
      print(user);

      UserDTO userDTO = UserDTO(
        id: user.id,
        email: user.email,
        name: user.displayName ?? '--',
        photoUrl: user.photoUrl ?? '',
      );

      String jsonString = jsonEncode(userDTO);
      DatabaseService.instance.saveData('user', jsonString);

      String defaultTimePeriod = await DatabaseService.instance.getData('defaultTimePeriod') ?? 'month';
      List<DateTime> dateRange = getDateRange(defaultTimePeriod, null);
      UserStateService.instance.init(defaultTimePeriod);
      _userState.setDefaultTimePeriod(defaultTimePeriod);
      _appState.setIsLoading(false);
      _appState.setDateRange(dateRange[0], dateRange[1]);
      // TODO: Need to send api request

      String categoriesString = DatabaseService.instance.getData('category');
      Map<String, dynamic> categories = jsonDecode(categoriesString);
      categories.forEach((id, category) {
        CategoryDTO categoryDto = CategoryDTO.fromJson(category);
        _appState.addCategory(categoryDto.id, categoryDto);
      });

      String accountsString = DatabaseService.instance.getData('account');
      Map<String, dynamic> accounts = jsonDecode(accountsString);
      accounts.forEach((id, account) {
        AccountDto accountDto = AccountDto.fromJson(account);
        _appState.addAccount(accountDto.id, accountDto);
      });

      String transactionsString = DatabaseService.instance.getData('transaction');
      Map<String, dynamic> transations = jsonDecode(transactionsString);
      transations.forEach((id, transaction) {
        transaction['account'] = _appState.accounts[transaction['account']];
        transaction['category'] = _appState.categories[transaction['category']];
        TransactionDto transactionDto = TransactionDto.fromJson(transaction);
        _appState.addTransaction(transactionDto.id, transactionDto);
      });

      String accountTransactionsString = DatabaseService.instance.getData('account-trnsaction');
      Map<String, dynamic> accountTransactions = jsonDecode(accountTransactionsString);
      accountTransactions.forEach((id, accountTransaction) {
        accountTransaction['fromAccount'] = _appState.accounts[accountTransaction['fromAccount']];
        accountTransaction['toAccount'] = _appState.accounts[accountTransaction['toAccount']];
        AccountTransactionDTO accountTransactionDto = AccountTransactionDTO.fromJson(accountTransaction);
        _appState.addAccountTrnsaction(accountTransactionDto.id, accountTransactionDto);
      });
      
    } else {
      print('222222222222222222222222222222222222222222');
    }
  }

  Future<void> checkAuth() async {
    // Check auth logic here
  }
}