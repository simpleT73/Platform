import 'package:account/provider/transaction_provider.dart';
import 'package:account/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller to handle search input
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("รายชื่อ Platform Live stream"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search Platform",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                var filteredTransactions = provider.transactions.where((transaction) {
                  return transaction.pName.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredTransactions.isEmpty) {
                  return const Center(
                    child: Text('ไม่มีรายการ'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      var statement = filteredTransactions[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: ListTile(
                          title: Text(statement.pName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ชื่อ Platform: ${statement.pName}', style: TextStyle(fontSize: 16)),
                              Text('ชื่อผู้ก่อตั้ง: ${statement.fName}', style: TextStyle(fontSize: 16)),
                              Text('วันที่เปิดให้บริการ: ${statement.pDate}', style: TextStyle(fontSize: 16)),
                              Text('จำนวนผู้ใช้งาน: ${statement.userAmount}', style: TextStyle(fontSize: 16)),
                              Text(
                                DateFormat('dd MMM yyyy hh:mm:ss').format(statement.date),
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          leading: CircleAvatar(
                            radius: 30,
                            child: FittedBox(
                              child: Text('${statement.pName[0].toUpperCase()}'),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.deleteTransaction(statement.keyID);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditScreen(statement: statement);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
