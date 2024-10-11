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
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Platform",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
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
                    child: Text(
                      'ไม่มีรายการ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      var statement = filteredTransactions[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: ListTile(
                          title: Text(
                            statement.pName,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'ชื่อ Platform: ${statement.pName}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'ชื่อผู้ก่อตั้ง: ${statement.fName}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'วันที่เปิดให้บริการ: ${statement.pDate}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'จำนวนผู้ใช้งาน: ${statement.userAmount}',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('dd MMM yyyy hh:mm:ss').format(statement.date),
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            child: FittedBox(
                              child: Text(
                                '${statement.pName[0].toUpperCase()}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
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
