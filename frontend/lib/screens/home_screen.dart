import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';
import 'add_transaction_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  double _totalIncome = 0;
  double _totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId != null) {
      final transactions = await _apiService.getTransactions(userId);
      
      double income = 0;
      double expense = 0;
      
      for (var tx in transactions) {
        if (tx.type == 'INCOME') {
          income += tx.amount;
        } else {
          expense += tx.amount;
        }
      }

      setState(() {
        _transactions = transactions;
        _totalIncome = income;
        _totalExpense = expense;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary Cards
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.green[100],
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text('Income',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                  '₹${_totalIncome.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          color: Colors.red[100],
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text('Expense',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                  '₹${_totalExpense.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Balance
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.blue[100],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Balance',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '₹${(_totalIncome - _totalExpense).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Transactions List
                Expanded(
                  child: _transactions.isEmpty
                      ? Center(child: Text('No transactions yet'))
                      : ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final tx = _transactions[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.type == 'INCOME'
                                    ? Colors.green
                                    : Colors.red,
                                child: Icon(
                                  tx.type == 'INCOME'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(tx.description),
                              subtitle: Text('${tx.category} • ${tx.date}'),
                              trailing: Text(
                                '₹${tx.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: tx.type == 'INCOME'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
          _loadTransactions();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
