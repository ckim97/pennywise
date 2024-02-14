import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/fetch_requests.dart';
import 'package:flutter_application_1/pages/plan.dart';

class Plan {
  final double monthly_income;
  final double savings;
  final double bills;
  final double entertainment;
  final double food;

  Plan({
    required this.monthly_income,
    required this.savings,
    required this.bills,
    required this.entertainment,
    required this.food,
  });
}

class Expense {
  final String category;
  final String description;
  final double amount;

  Expense({
    required this.category,
    required this.description,
    required this.amount,
  });
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final ApiService apiService = ApiService('http://localhost:5555');
  late Future<Plan?> _planFuture;
  late Future<List<dynamic>> _expensesFuture;
  late Plan? _plan;
  late Map<String, double> categoryTotalBudget;
  late Map<String, double> categoryTotalExpenses;
  late Map<String, double> categoryRemainingBalance;

  @override
  void initState() {
    super.initState();
    _planFuture = _fetchPlan();
    _expensesFuture = _fetchExpenses();
    categoryTotalBudget = {
      'Savings': 0,
      'Bills': 0,
      'Entertainment': 0,
      'Food': 0,
    };
    categoryTotalExpenses = {
      'Savings': 0,
      'Bills': 0,
      'Entertainment': 0,
      'Food': 0,
    };
    categoryRemainingBalance = {
      'Savings': 0,
      'Bills': 0,
      'Entertainment': 0,
      'Food': 0,
    };
  }

  Future<Plan?> _fetchPlan() async {
    try {
      final result = await apiService.get('plans/1');
      final planData = result;

      if (planData != null) {
        setState(() {
          _plan = Plan(
            monthly_income: planData['monthly_income'],
            savings: planData['savings'],
            bills: planData['bills'],
            entertainment: planData['entertainment'],
            food: planData['food'],
          );

          
          categoryTotalBudget = {
            'Savings': (_plan!.monthly_income * (_plan!.savings / 100)),
            'Bills': (_plan!.monthly_income * (_plan!.bills / 100)),
            'Entertainment': (_plan!.monthly_income * (_plan!.entertainment / 100)),
            'Food': (_plan!.monthly_income * (_plan!.food / 100)),
          };

          
          categoryRemainingBalance = {...categoryTotalBudget};
        });
      }
    } catch (e) {
      print('Error fetching plan: $e');
      setState(() {
        _plan = null;
      });
      rethrow;
    }
    return _plan;
  }

  Future<List<dynamic>> _fetchExpenses() async {
    try {
      final result = await apiService.get('expenses/1');
      print(result);
      print(result.runtimeType);

      final List<dynamic> expenses = result['expenses']
          .map((expenseData) => Expense(
                category: expenseData['category'],
                description: expenseData['description'],
                amount: (expenseData['amount'] as num).toDouble(),
              ))
          .toList();

      for (var expense in expenses) {
        final category = expense.category;
        final amount = expense.amount.toDouble();

        
        categoryTotalExpenses[category] = categoryTotalExpenses[category]! + amount;

        
        categoryRemainingBalance[category] = (categoryRemainingBalance[category] ?? 0) - amount;
      }

      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P R O G R E S S"),
        backgroundColor: Colors.blue,
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Plan?>(
            future: _planFuture,
            builder: (context, planSnapshot) {
              if (planSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (planSnapshot.hasError || planSnapshot.data == null) {
                return _buildNoPlanWidget();
              } else {
                final plan = planSnapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMonthlyBudgetOverview(plan),
                    SizedBox(height: 5),
                    _buildRemainingBalance(plan),
                    SizedBox(height: 5),
                    FutureBuilder<List<dynamic>>(
                      future: _expensesFuture,
                      builder: (context, expensesSnapshot) {
                        if (expensesSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (expensesSnapshot.hasError) {
                          return Text('Error fetching expenses: ${expensesSnapshot.error}', style: TextStyle(fontSize: 16));
                        } else if (!expensesSnapshot.hasData) {
                          return Text('No expenses data available', style: TextStyle(fontSize: 16));
                        } else {
                          final expenses = expensesSnapshot.data!;

                          // Initialize categoryTotalExpenses with all categories set to 0
                          Map<String, double> categoryTotalExpenses = {
                            'Savings': 0,
                            'Bills': 0,
                            'Entertainment': 0,
                            'Food': 0,
                          };

                          for (var expense in expenses) {
                            final category = expense.category;
                            final amount = expense.amount.toDouble();

                            categoryTotalExpenses[category] = (categoryTotalExpenses[category] ?? 0) + amount;
                          }
                          print(categoryTotalExpenses);
                          return _buildBarChart(plan, categoryTotalExpenses);
                        }
                      },
                    )

                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoPlanWidget() {
    return Column(
      children: [
        Text("Currently No Plan in Place. Please enter a Monthly Savings Plan"),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlanPage()),
            );
          },
          child: Text('Go to Plan Page'),
        ),
      ],
    );
  }

  Widget _buildMonthlyBudgetOverview(Plan plan) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Monthly Income: \$${plan.monthly_income.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            _buildBudgetTile('Savings', categoryTotalBudget['Savings']),
            _buildBudgetTile('Bills', categoryTotalBudget['Bills']),
            _buildBudgetTile('Entertainment', categoryTotalBudget['Entertainment']),
            _buildBudgetTile('Food', categoryTotalBudget['Food']),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetTile(String category, double? amount) {
    return ListTile(
      title: Text('$category: \$${amount?.toStringAsFixed(2) ?? 'N/A'}', style: TextStyle(fontSize: 16)),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildRemainingBalance(Plan plan) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Remaining Balance:', style: TextStyle(fontSize: 16)),
            FutureBuilder<List<dynamic>>(
              future: _expensesFuture,
              builder: (context, expensesSnapshot) {
                if (expensesSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (expensesSnapshot.hasError) {
                  return Text('Error fetching expenses: ${expensesSnapshot.error}');
                } else if (!expensesSnapshot.hasData) {
                  return Text('No expenses data available');
                } else {
                  final expenses = expensesSnapshot.data!;
                  Map<String, double> remainingBalances = {...categoryTotalBudget};

                  for (var expense in expenses) {
                    final category = expense.category;
                    final amount = expense.amount.toDouble();

                    remainingBalances[category] = (remainingBalances[category] ?? 0) - amount;
                  }

                  return Column(
                    children: [
                      for (var category in remainingBalances.keys)
                        ListTile(
                          title: Text('$category Remaining Balance: \$${remainingBalances[category]!.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBarChart(Plan plan, Map<String, double> categoryTotalExpenses) {
    return plan.monthly_income != 0
        ? Container(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                groupsSpace: 40,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barsSpace: 8,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: categoryTotalExpenses['Savings'] ?? 0,
                        width: 16,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barsSpace: 8,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: categoryTotalExpenses['Bills'] ?? 0,
                        width: 16,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barsSpace: 8,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: categoryTotalExpenses['Entertainment'] ?? 0,
                        width: 16,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barsSpace: 8,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: categoryTotalExpenses['Food'] ?? 0,
                        width: 16,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 44,
                      showTitles: true,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 30,
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}






