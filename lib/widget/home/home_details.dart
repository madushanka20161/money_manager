import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/currency.dart';
import 'package:money_manager_3/helper/number-format.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:money_manager_3/widget/transaction/transaction_list.dart';
import 'package:provider/provider.dart';

/// Aggregated totals for one category, used to render a single row.
class _CategorySummary {
  _CategorySummary(this.categoryId, double initialAmount, TransactionDto first)
      : total = initialAmount,
        transactions = [first];

  final String categoryId;
  double total;
  double percentage = 0;
  final List<TransactionDto> transactions;

  void add(double amount, TransactionDto transaction) {
    total += amount;
    transactions.add(transaction);
  }
}

class HomeDetails extends StatefulWidget {
  const HomeDetails({
    super.key,
    required this.income,
    required this.expenses,
  });

  final List<TransactionDto> income;
  final List<TransactionDto> expenses;

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);
  TransactionType _selectedTab = TransactionType.expenses;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Groups [transactions] by category, converts amounts to [displayCurrency],
  /// and sorts the result from largest to smallest total.
  ///
  /// Returns a fresh list every call — callers must capture it in a local
  /// variable and use that same reference for both itemCount and itemBuilder.
  /// Reading a shared mutable field from itemBuilder is what causes
  /// "RangeError: Valid value range is empty" once the field is reassigned
  /// by a later build before the old ListView has finished laying out.
  List<_CategorySummary> _summarizeByCategory(List<TransactionDto> transactions, String displayCurrency) {
    final byCategory = <String, _CategorySummary>{};
    var grandTotal = 0.0;

    for (final transaction in transactions) {
      final amount = convertCurrency(
        transaction.account.currency,
        displayCurrency,
        transaction.amount,
      );
      grandTotal += amount;

      final categoryId = transaction.category.id;
      final existing = byCategory[categoryId];

      if (existing == null) {
        byCategory[categoryId] =
            _CategorySummary(categoryId, amount, transaction);
      } else {
        existing.add(amount, transaction);
      }
    }

    final summaries = byCategory.values.toList();

    for (final summary in summaries) {
      summary.percentage = grandTotal == 0 ? 0 : (summary.total / grandTotal) * 100;
    }

    summaries.sort((a, b) => b.total.compareTo(a.total));
    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final categories = appState.categories;
    final displayCurrency = getDisplayCurrency(appState.selectedAccountId);
    final timePeriod = context.watch<UserState>().defaultTimePeriod!;

    final expenseSummaries = _summarizeByCategory(widget.expenses, displayCurrency);
    final incomeSummaries = _summarizeByCategory(widget.income, displayCurrency);

    return Column(
      children: [
        _buildTabBar(appState.setSelectedTransactionType),
        Expanded(
          child: TabBarView(
            // TODO [V2 - need to enable tab changes using swiping]
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              _buildCategoryList(
                summaries: expenseSummaries,
                categories: categories,
                timePeriod: timePeriod,
                displayCurrency: displayCurrency,
                type: TransactionType.expenses,
              ),
              _buildCategoryList(
                summaries: incomeSummaries,
                categories: categories,
                timePeriod: timePeriod,
                displayCurrency: displayCurrency,
                type: TransactionType.income,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(Function setSelectedTransactionType) {
    final tabWidth = MediaQuery.of(context).size.width / 2;

    return TabBar(
      controller: _tabController,
      labelColor: AppConfig.fontColor,
      labelStyle: TextStyle(fontSize: AppConfig.fontSize),
      unselectedLabelColor: AppConfig.fontColor.withOpacity(0.5),
      padding: const EdgeInsets.all(5),
      indicator: BoxDecoration(
        color: AppConfig.buttonSelectedColor,
        borderRadius: BorderRadius.circular(10),
      ),
      tabs: [
        SizedBox(width: tabWidth, child: const Tab(text: 'Expenses')),
        SizedBox(width: tabWidth, child: const Tab(text: 'Income')),
      ],
      onTap: (index) {
        setState(() {
          _selectedTab =
              index == 0 ? TransactionType.expenses : TransactionType.income;
        });
        setSelectedTransactionType(_selectedTab);
      },
    );
  }

  Widget _buildCategoryList({
    required List<_CategorySummary> summaries,
    required Map<String, CategoryDTO> categories,
    required String timePeriod,
    required String displayCurrency,
    required TransactionType type,
  }) {
    if (summaries.isEmpty) {
      return const _EmptyTransactions();
    }

    return ListView.builder(
      itemCount: summaries.length,
      itemBuilder: (context, index) {
        final summary = summaries[index];
        final category = categories[summary.categoryId]!;
        final limitPoint = _limitPointFor(category, summary, timePeriod);

        return _CategoryTile(
          summary: summary,
          category: category,
          displayCurrency: displayCurrency,
          limitPoint: limitPoint,
          isOverLimit: limitPoint > 1,
          onTap: () => _openCategoryTransactions(type, category),
        );
      },
    );
  }

  /// Ratio of spend to limit for [category] in the current period.
  /// 1.0 means exactly at the limit; above 1.0 means over it.
  /// Returns 0 when the category has no limit, or the limit doesn't apply
  /// to the current time period.
  double _limitPointFor(
    CategoryDTO category,
    _CategorySummary summary,
    String timePeriod,
  ) {
    final hasLimit =
        category.limit.limit > 0 && timePeriod == TimePeriod.month.displayName;

    if (!hasLimit) return 0;

    return category.limit.type == CategoryLimitType.percentage
        ? summary.percentage / category.limit.limit
        : summary.total / category.limit.limit;
  }

  void _openCategoryTransactions(TransactionType type, CategoryDTO category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TransactionList(trnsactionType: type, category: category),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

/// Shown in place of the list when the selected tab has no transactions.
class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: AppConfig.fontColor.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'No transactions',
              style: TextStyle(
                fontSize: AppConfig.fontSize,
                color: AppConfig.fontColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One row in the category list: icon, name, total and a limit-progress bar
/// drawn as a two-stop gradient background. Shows a warning icon next to the
/// total whenever spend has gone past the category's limit.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.summary,
    required this.category,
    required this.displayCurrency,
    required this.limitPoint,
    required this.isOverLimit,
    required this.onTap,
  });

  final _CategorySummary summary;
  final CategoryDTO category;
  final String displayCurrency;
  final double limitPoint;
  final bool isOverLimit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Clamp so the gradient stops stay valid even if spending exceeds the limit.
    final clampedLimitPoint = limitPoint.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                category.iconColor.withOpacity(0.4),
                category.iconColor.withOpacity(0.4),
                const Color.fromARGB(34, 255, 255, 255),
                const Color.fromARGB(34, 255, 255, 255),
              ],
              stops: [0.0, clampedLimitPoint, clampedLimitPoint, 1.0],
            ),
            border: isOverLimit
                ? Border.all(color: Colors.redAccent.withOpacity(0.6), width: 1)
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: AppConfig.padding,
              right: AppConfig.padding,
            ),
            child: Row(
              children: [
                _CategoryIcon(category: category),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: AppConfig.fontSize,
                              color: AppConfig.fontColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isOverLimit) ...[
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      size: 14,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Flexible(
                                    child: Text(
                                      '$displayCurrency: ${formatNumber(summary.total)}',
                                      style: TextStyle(
                                        fontSize: AppConfig.fontSize,
                                        color: isOverLimit
                                            ? Colors.redAccent
                                            : AppConfig.fontColor,
                                        fontWeight: isOverLimit
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${summary.percentage.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: AppConfig.fontSize,
                                  color: AppConfig.fontColor,
                                ),
                                overflow: TextOverflow.ellipsis,
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
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final CategoryDTO category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: category.iconColor.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(category.icon, size: 20, color: Colors.white),
      ),
    );
  }
}