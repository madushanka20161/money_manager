import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_manager_3/dto/account_dto.dart';
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
      print('////////////////////////////////////////////// 11222');
      print('-------------------------------------111');
      // TODO: Need to send api request




      print('333333333333333333333333333333333');

      // this part for testing
      String account01 = '1|Main Account|Rs|1000.0|';
      String account02 = '2|Sampath savings|Rs|5000.0|';
      List<String> accounts = [account01, account02];
      accounts.forEach((account) {
        AccountDto accountDto = AccountDto.fromPipedString(account);
        _appState.addAccount(accountDto.id, accountDto);
      });

      // // this part for transaction testing
      // String transaction01 = '1|1|100|1|income|2025-01-01|Salary';
      // String transaction02 = '2|2|50|2|expenses|2025-01-22|Groceries';
      // String transaction03 = '3|1|200|3|expenses|2025-01-02|Rent';
      // String transaction04 = '4|2|300|1|income|2025-01-23|Salary';
      // String transaction05 = '5|1|150|2|expenses|2025-01-03|Utilities';
      // String transaction06 = '6|2|75|3|expenses|2025-01-04|Transport';
      // String transaction07 = '7|1|300|1|income|2025-01-05|Freelance';
      // String transaction08 = '8|2|50|2|expenses|2025-01-06|Dining';
      // String transaction09 = '9|1|100|3|expenses|2025-01-07|Entertainment';
      // String transaction10 = '10|2|200|1|income|2025-01-08|Bonus';
      // String transaction11 = '11|1|250|2|expenses|2025-01-09|Shopping';
      // String transaction12 = '12|2|1250|3|expenses|2025-01-10|Medical';
      // String transaction13 = '13|1|175|1|income|2025-01-11|Investment';
      // String transaction14 = '14|2|60|2|expenses|2025-01-12|Snacks';
      // String transaction15 = '15|1|90|3|expenses|2025-01-13|Gym';
      // String transaction16 = '16|2|220|1|income|2025-01-14|Gift';
      // String transaction17 = '17|1|130|2|expenses|2025-01-15|Fuel';
      // String transaction18 = '18|2|80|3|expenses|2025-01-16|Subscription';
      // String transaction19 = '19|1|110|1|income|2025-01-17|Refund';
      // String transaction20 = '20|2|95|2|expenses|2025-01-18|Books';
      // String transaction21 = '21|1|140|3|expenses|2025-01-22|Laundry';
      // String transaction22 = '22|2|160|1|income|2025-01-20|Commission';
      // String transaction23 = '23|1|85|2|expenses|2025-01-23|Parking';
      // String transaction24 = '24|2|70|3|expenses|2025-01-22|Coffee';

      // List<String> transactions = [
      //   transaction01, transaction02, transaction03, transaction04,
      //   transaction05, transaction06, transaction07, transaction08,
      //   transaction09, transaction10, transaction11, transaction12,
      //   transaction13, transaction14, transaction15, transaction16,
      //   transaction17, transaction18, transaction19, transaction20,
      //   transaction21, transaction22, transaction23, transaction24
      // ];
      // transactions.forEach((transaction) {
      //   TransactionDto transactionDto = TransactionDto.fromPipedString(transaction);
      //   _appState.addTransaction(transactionDto.id.toString(), transactionDto);
      // });


      // // this part for category testing
      // String category01 = '1|Salary|income|attach_money|red';
      // String category02 = '2|Groceries|expenses|shopping_cart|red';
      // String category03 = '3|Rent|expenses|home|red';
      // String category04 = '4|Medical|expenses|home|red';
      // String category05 = '5|Travel|expenses|home|red';
      // String category06 = '6|Party|expenses|home|red';
      // String category07 = '7|school|expenses|home|red';
      // String category08 = '8|class|expenses|home|red';
      // String category09 = '9|night|expenses|home|red';
      // List<String> categories = [category01, category02, category03, category04, category05, category06, category07, category08, category09];
      // categories.forEach((category) {
      //   CategoryDTO categoryDto = CategoryDTO.fromPipedString(category);
      //   _appState.addCategory(categoryDto.id, categoryDto);
      // });

      String categoriesString = DatabaseService.instance.getData('category');
      Map<String, dynamic> categories = jsonDecode(categoriesString);
      categories.forEach((id, category) {
        CategoryDTO categoryDto = CategoryDTO.fromJson(category);
        _appState.addCategory(categoryDto.id, categoryDto);
      });

      String transactionsString = DatabaseService.instance.getData('transaction');
      Map<String, dynamic> transations = jsonDecode(transactionsString);
      transations.forEach((id, transaction) {
        transaction['account'] = _appState.accounts[transaction['account']];
        transaction['category'] = _appState.categories[transaction['category']];
        TransactionDto transactionDto = TransactionDto.fromJson(transaction);
        _appState.addTransaction(transactionDto.id, transactionDto);
      });


    } else {
      print('222222222222222222222222222222222222222222');
    }
  }

  Future<void> checkAuth() async {
    // Check auth logic here
  }
}