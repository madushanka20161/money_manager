import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';

class TransactionList extends StatefulWidget {
  final List<TransactionDto> transactions;
  final CategoryDTO category;

  TransactionList({
    required this.transactions,
    required this.category
  });

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late List<TransactionDto> list;

  @override
  void initState() {
    super.initState();
    list = widget.transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // // Implement search functionality
              // setState(() {
              //   showSearch(
              //     context: context,
              //     delegate: TransactionSearchDelegate(list),
              //   );
              // });
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Implement download functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${list[index].description} | ${list[index].amount} | ${list[index].account}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add transaction functionality
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// class TransactionSearchDelegate extends SearchDelegate<TransactionDto> {
//   final List<TransactionDto> transactions;

//   TransactionSearchDelegate(this.transactions);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, transactions[0]); // Pass a default or empty TransactionDto object
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = transactions.where((transaction) =>
//         transaction.description.toLowerCase().contains(query.toLowerCase()));

//     return ListView(
//       children: results
//           .map<ListTile>((transaction) => ListTile(
//                 title: Text(transaction.description),
//               ))
//           .toList(),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = transactions.where((transaction) =>
//         transaction.description.toLowerCase().contains(query.toLowerCase()));

//     return ListView(
//       children: suggestions
//           .map<ListTile>((transaction) => ListTile(
//                 title: Text(transaction.description),
//               ))
//           .toList(),
//     );
//   }
// }