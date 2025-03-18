import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:money_manager_3/widget/transaction/transaction_list.dart';
import 'package:provider/provider.dart';

class HomeDetails extends StatefulWidget {
  final List<TransactionDto> income;
  final List<TransactionDto> expenses;

  HomeDetails({
    required this.income, 
    required this.expenses,
  });

  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> transactionByCategory = {};
  double total = 0;
  TransactionType selectedTab = TransactionType.expenses;
  Function? setSelectedTransactionType;
  String timePeriod = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void generateTransactionByCategory() {
    List<TransactionDto> collection = (selectedTab == TransactionType.income) ? widget.income : widget.expenses;
    transactionByCategory.clear();
    total = 0;

    for (var transaction in collection) {
      total = total + transaction.amount;

      if (transactionByCategory[transaction.category.id] == null) {
        transactionByCategory[transaction.category.id] = {
          'total': transaction.amount,
          'transaction': [transaction]
        };
      } else {
        transactionByCategory[transaction.category.id]['total'] = transactionByCategory[transaction.category.id]['total'] + transaction.amount;
        transactionByCategory[transaction.category.id]['transaction'].add(transaction);
      }
    }

    transactionByCategory.forEach((key, value) {
      value['percentage'] = (value['total'] / total) * 100;
    });

    transactionByCategory = Map.fromEntries(
      transactionByCategory.entries.toList()
      ..sort((a, b) => b.value['total'].compareTo(a.value['total']))
    );
  }

  void onTabChanged(int value) {
    if (value.toString() == '0') {
      selectedTab = TransactionType.expenses;
    } else {
      selectedTab = TransactionType.income;
    }

    setSelectedTransactionType!(selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    generateTransactionByCategory();
    final accounts = context.watch<AppState>().accounts;
    final category = context.watch<AppState>().categories;
    setSelectedTransactionType = context.watch<AppState>().setSelectedTransactionType;
    timePeriod = context.watch<UserState>().defaultTimePeriod!;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppConfig.fontColor,
          labelStyle: TextStyle(fontSize: AppConfig.fontSize),
          unselectedLabelColor: AppConfig.fontColor.withOpacity(0.5),
          padding: EdgeInsets.all(5),
          indicator: BoxDecoration(
            color: AppConfig.buttonSelectedColor,
            borderRadius: BorderRadius.circular(10),
          ),
          tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2, // ✅ Set width for selected tab
              child: Tab(text: 'Expenses'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2, // ✅ Set width for selected tab
              child: Tab(text: 'Income'),
            ),
          ],
          onTap: (value) {
            onTabChanged(value);
          },
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildListView(
                TransactionType.expenses.toString(), accounts, category
              ),
              _buildListView(
                TransactionType.income.toString(), accounts, category
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView(String type, Map<String, AccountDto> accounts, Map<String, CategoryDTO> categories) {
    final List<String> keyList = transactionByCategory.keys.toList();

    return ListView.builder(
      itemCount: keyList.length,
      itemBuilder: (context, index) {
        final data = transactionByCategory[keyList[index]];

        if (data ==  null) {
          return null;
        }

        CategoryDTO categoryDTO = categories[keyList[index]]!;
        double limitPoint = 0.4;

        if (categoryDTO.limit.limit > 0 && timePeriod == TimePeriod.month.displayName) {
          if (categoryDTO.limit.type == CategoryLimitType.percentage) {
            limitPoint = categoryDTO.limit.limit / data['percentage'];
          } else {
            limitPoint = categoryDTO.limit.limit / data['total'];
          }
        } else {
          limitPoint = 0;
        }
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TransactionList(
                  trnsactionType: selectedTab,
                  category: categories[keyList[index]]!,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                // color: const Color.fromARGB(34, 255, 255, 255),
                gradient: LinearGradient(
                  colors: [categoryDTO.iconColor.withOpacity(0.4), categoryDTO.iconColor.withOpacity(0.4), Color.fromARGB(34, 255, 255, 255), Color.fromARGB(34, 255, 255, 255)], // Define colors
                  stops: [0.0, limitPoint, limitPoint, 1.0], // 40% Red, 60% Green
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 45, // ✅ Background circle size
                      height: 45,
                      decoration: BoxDecoration(
                        color: categories[keyList[index]]!
                            .iconColor
                            .withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(categories[keyList[index]]!.icon,
                            size: 30, color: Colors.white),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                categories[keyList[index]]!.name,
                                style: TextStyle(
                                    fontSize: AppConfig.fontSize,
                                    color: AppConfig.fontColor),
                                overflow: TextOverflow
                                    .ellipsis, // ✅ Truncate if needed
                                maxLines: 1, // ✅ Keeps it on one line
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    '$defaultCurrency: ${data['total']}',
                                    style: TextStyle(
                                        fontSize: AppConfig.fontSize,
                                        color: AppConfig.fontColor),
                                    overflow: TextOverflow
                                        .ellipsis, // ✅ Prevents breaking UI
                                    maxLines: 1,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '${data['percentage'].toStringAsFixed(2)}%',
                                    style: TextStyle(
                                        fontSize: AppConfig.fontSize,
                                        color: AppConfig.fontColor),
                                    overflow: TextOverflow
                                        .ellipsis, // ✅ Prevents UI breakage
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ); 
      },
    );
  }
}