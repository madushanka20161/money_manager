import 'package:flutter/material.dart';

class HomeDetails extends StatefulWidget {
  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
      return Column(
        // children: [Text('Home Details')],
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Income'),
              Tab(text: 'Expenses'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView('Income'),
                _buildListView('Expenses'),
              ],
            ),
          ),
        ],
      );
    // );
  }

  Widget _buildListView(String type) {
    List<Map<String, dynamic>> data = [
      {'icon': Icons.attach_money, 'amount': 100, 'account': 'Bank', 'description': 'Salary'},
      {'icon': Icons.money_off, 'amount': 50, 'account': 'Cash', 'description': 'Groceries'},
    ];

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(data[index]['icon']),
          title: Text('${data[index]['amount']} | ${data[index]['account']}'),
          subtitle: Text(data[index]['description']),
        );
      },
    );
  }
}