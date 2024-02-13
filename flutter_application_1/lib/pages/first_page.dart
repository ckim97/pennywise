// / this one is the good one// 


// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_application_1/pages/plan.dart';


// class Plan {
//   final double monthly_income;
//   final double savings;
//   final double bills;
//   final double entertainment;
//   final double food;

//   Plan({
//     required this.monthly_income,
//     required this.savings,
//     required this.bills,
//     required this.entertainment,
//     required this.food,
//   });
// }

// class Expense {
//   final String category;
//   final String description;
//   final double amount;

//   Expense({
//     required this.category,
//     required this.description,
//     required this.amount,
//   });
// }

// class FirstPage extends StatefulWidget {
//   const FirstPage({Key? key}) : super(key: key);

//   @override
//   _FirstPageState createState() => _FirstPageState();
// }

// class _FirstPageState extends State<FirstPage> {
//   final ApiService apiService = ApiService('http://localhost:5555');
//   late Future<Plan?> _planFuture;
//   late Future<List<dynamic>> _expensesFuture;
//   late Plan? _plan; // Declare _plan as a nullable member variable

//   @override
//   void initState() {
//     super.initState();
//     _planFuture = _fetchPlan();
//     _expensesFuture = _fetchExpenses();
//   }

//   Future<Plan?> _fetchPlan() async {
//     try {
//       final result = await apiService.get('plans/1');
//       final planData = result;

//       if (planData != null) {
//         setState(() {
//           _plan = Plan(
//             monthly_income: planData['monthly_income'],
//             savings: planData['savings'],
//             bills: planData['bills'],
//             entertainment: planData['entertainment'],
//             food: planData['food'],
//           );
//         });
//       }
//     } catch (e) {
//       print('Error fetching plan: $e');
//       setState(() {
//         _plan = null; // Set _plan to null in case of an error
//       });
//       rethrow;
//     }
//     return _plan;
//   }

//   Future<List<dynamic>> _fetchExpenses() async {
//     try {
//       final result = await apiService.get('expenses/1');
//       print(result);
//       print(result.runtimeType);

//       final List<dynamic> expenses = result['expenses']
//           .map((expenseData) => Expense(
//                 category: expenseData['category'],
//                 description: expenseData['description'],
//                 amount: (expenseData['amount'] as num).toDouble(),
//               ))
//           .toList();

//       return expenses;
//     } catch (e) {
//       print('Error fetching expenses: $e');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Progress")),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<Plan?>(
//             future: _planFuture,
//             builder: (context, planSnapshot) {
//               if (planSnapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (planSnapshot.hasError || planSnapshot.data == null) {
//                 return Column(
//                   children: [
//                     Text("Currently No Plan in Place. Please enter a Monthly Savings Plan"),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => PlanPage()),
//                         );
//                       },
//                       child: Text('Go to Plan Page'),
//                     ),





//                   ],
//                 );
//               } else {
//                 final plan = planSnapshot.data!;
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Card(
//                       elevation: 5,
//                       margin: EdgeInsets.all(16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text('Monthly Income: \$${plan.monthly_income.toStringAsFixed(2)}'),
//                             Text('Savings: ${plan.savings.toInt()}%'),
//                             Text('Bills: ${plan.bills.toInt()}%'),
//                             Text('Entertainment: ${plan.entertainment.toInt()}%'),
//                             Text('Food: ${plan.food.toInt()}%'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     FutureBuilder<List<dynamic>>(
//                       future: _expensesFuture,
//                       builder: (context, expensesSnapshot) {
//                         if (expensesSnapshot.connectionState == ConnectionState.waiting) {
//                           return CircularProgressIndicator();
//                         } else if (expensesSnapshot.hasError) {
//                           return Text('Error fetching expenses: ${expensesSnapshot.error}');
//                         } else if (!expensesSnapshot.hasData) {
//                           return Text('No expenses data available');
//                         } else {
//                           final expenses = expensesSnapshot.data!;

//                           Map<String, double> categoryTotalExpenses = {};

//                           for (var expense in expenses) {
//                             final category = expense.category;
//                             final amount = expense.amount.toDouble();

//                             categoryTotalExpenses[category] =
//                                 (categoryTotalExpenses[category] ?? 0.0) + amount;
//                           }

//                           return Column(
//                             children: [
//                               Card(
//                                 elevation: 5,
//                                 margin: EdgeInsets.all(16),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     children: [
//                                       Text('Expenses:'),
//                                       for (var category in categoryTotalExpenses.keys)
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text('Category: $category'),
//                                             Text(
//                                                 'Total Amount: \$${categoryTotalExpenses[category]!.toStringAsFixed(2)}'),
//                                             SizedBox(height: 8),
//                                           ],
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 16),
//                               if (plan != null && plan.monthly_income != 0)
//                                 Container(
//                                   height: 300,
//                                   child: BarChart(
//                                     BarChartData(
//                                       alignment: BarChartAlignment.center,
//                                       groupsSpace: 40,
//                                       barGroups: [
//                                         BarChartGroupData(
//                                           x: 0,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Savings'] ?? 0,
//                                               width: 16,
//                                               color: Colors.blue,
//                                             ),
//                                           ],
//                                         ),
//                                         BarChartGroupData(
//                                           x: 1,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Bills'] ?? 0,
//                                               width: 16,
//                                               color: Colors.green,
//                                             ),
//                                           ],
//                                         ),
//                                         BarChartGroupData(
//                                           x: 2,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Entertainment'] ?? 0,
//                                               width: 16,
//                                               color: Colors.orange,
//                                             ),
//                                           ],
//                                         ),
//                                         BarChartGroupData(
//                                           x: 3,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Food'] ?? 0,
//                                               width: 16,
//                                               color: Colors.red,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                       titlesData: FlTitlesData(
//                                         leftTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                             reservedSize: 44,
//                                             showTitles: true,
//                                           ),
//                                         ),
//                                         bottomTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                             reservedSize: 30,
//                                             showTitles: true,
//                                             getTitlesWidget: (double value, TitleMeta meta) {
//                                               switch (value.toInt()) {
//                                                 case 0:
//                                                   return Text('Savings', style: TextStyle(fontSize: 10));
//                                                 case 1:
//                                                   return Text('Bills', style: TextStyle(fontSize: 10));
//                                                 case 2:
//                                                   return Text('Entertainment', style: TextStyle(fontSize: 10));
//                                                 case 3:
//                                                   return Text('Food', style: TextStyle(fontSize: 10));
//                                                 default:
//                                                   return Container();
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }





// shows remaining balance // 


// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_application_1/fetch_requests.dart';
// import 'package:flutter_application_1/pages/plan.dart';

// class Plan {
//   final double monthly_income;
//   final double savings;
//   final double bills;
//   final double entertainment;
//   final double food;

//   Plan({
//     required this.monthly_income,
//     required this.savings,
//     required this.bills,
//     required this.entertainment,
//     required this.food,
//   });
// }

// class Expense {
//   final String category;
//   final String description;
//   final double amount;

//   Expense({
//     required this.category,
//     required this.description,
//     required this.amount,
//   });
// }

// class FirstPage extends StatefulWidget {
//   const FirstPage({Key? key}) : super(key: key);

//   @override
//   _FirstPageState createState() => _FirstPageState();
// }

// class _FirstPageState extends State<FirstPage> {
//   final ApiService apiService = ApiService('http://localhost:5555');
//   late Future<Plan?> _planFuture;
//   late Future<List<dynamic>> _expensesFuture;
//   late Plan? _plan;
//   late Map<String, double> categoryTotalBudget;

//   @override
//   void initState() {
//     super.initState();
//     _planFuture = _fetchPlan();
//     _expensesFuture = _fetchExpenses();
//     categoryTotalBudget = {};
//   }

//   Future<Plan?> _fetchPlan() async {
//     try {
//       final result = await apiService.get('plans/1');
//       final planData = result;

//       if (planData != null) {
//         setState(() {
//           _plan = Plan(
//             monthly_income: planData['monthly_income'],
//             savings: planData['savings'],
//             bills: planData['bills'],
//             entertainment: planData['entertainment'],
//             food: planData['food'],
//           );

//           // Calculate total budget for each category based on the monthly income and percentage
//           categoryTotalBudget = {
//             'Savings': (_plan!.monthly_income * (_plan!.savings / 100)),
//             'Bills': (_plan!.monthly_income * (_plan!.bills / 100)),
//             'Entertainment': (_plan!.monthly_income * (_plan!.entertainment / 100)),
//             'Food': (_plan!.monthly_income * (_plan!.food / 100)),
//           };
//         });
//       }
//     } catch (e) {
//       print('Error fetching plan: $e');
//       setState(() {
//         _plan = null;
//       });
//       rethrow;
//     }
//     return _plan;
//   }

//   Future<List<dynamic>> _fetchExpenses() async {
//     try {
//       final result = await apiService.get('expenses/1');
//       print(result);
//       print(result.runtimeType);

//       final List<dynamic> expenses = result['expenses']
//           .map((expenseData) => Expense(
//                 category: expenseData['category'],
//                 description: expenseData['description'],
//                 amount: (expenseData['amount'] as num).toDouble(),
//               ))
//           .toList();

//       return expenses;
//     } catch (e) {
//       print('Error fetching expenses: $e');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Progress")),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<Plan?>(
//             future: _planFuture,
//             builder: (context, planSnapshot) {
//               if (planSnapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (planSnapshot.hasError || planSnapshot.data == null) {
//                 return Column(
//                   children: [
//                     Text("Currently No Plan in Place. Please enter a Monthly Savings Plan"),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => PlanPage()),
//                         );
//                       },
//                       child: Text('Go to Plan Page'),
//                     ),
//                   ],
//                 );
//               } else {
//                 final plan = planSnapshot.data!;
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Card(
//                       elevation: 5,
//                       margin: EdgeInsets.all(16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text('Monthly Income: \$${plan.monthly_income.toStringAsFixed(2)}'),
//                             Text('Savings: \$${categoryTotalBudget['Savings']!.toStringAsFixed(2)}'),
//                             Text('Bills: \$${categoryTotalBudget['Bills']!.toStringAsFixed(2)}'),
//                             Text('Entertainment: \$${categoryTotalBudget['Entertainment']!.toStringAsFixed(2)}'),
//                             Text('Food: \$${categoryTotalBudget['Food']!.toStringAsFixed(2)}'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     FutureBuilder<List<dynamic>>(
//                       future: _expensesFuture,
//                       builder: (context, expensesSnapshot) {
//                         if (expensesSnapshot.connectionState == ConnectionState.waiting) {
//                           return CircularProgressIndicator();
//                         } else if (expensesSnapshot.hasError) {
//                           return Text('Error fetching expenses: ${expensesSnapshot.error}');
//                         } else if (!expensesSnapshot.hasData) {
//                           return Text('No expenses data available');
//                         } else {
//                           final expenses = expensesSnapshot.data!;
//                           Map<String, double> categoryTotalExpenses = {};

//                           for (var expense in expenses) {
//                             final category = expense.category;
//                             final amount = expense.amount.toDouble();

//                             categoryTotalExpenses[category] =
//                                 (categoryTotalExpenses[category] ?? categoryTotalBudget[category]!) - amount;
//                           }

//                           return Column(
//                             children: [
//                               Card(
//                                 elevation: 5,
//                                 margin: EdgeInsets.all(16),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     children: [
//                                       Text('Expenses:'),
//                                       for (var category in categoryTotalExpenses.keys)
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text('Category: $category'),
//                                             Text(
//                                                 'Total Amount: \$${categoryTotalExpenses[category]!.toStringAsFixed(2)}'),
//                                             SizedBox(height: 8),
//                                           ],
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 16),
//                               if (plan != null && plan.monthly_income != 0)
//                                 Container(
//                                   height: 300,
//                                   child: BarChart(
//                                     BarChartData(
//                                       alignment: BarChartAlignment.center,
//                                       groupsSpace: 40,
//                                       barGroups: [
//                                         BarChartGroupData(
//                                           x: 0,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Savings'] ?? 0,
//                                               width: 16,
//                                               color: Colors.blue,
//                                             ),
//                                           ],
//                                         ),
//                                         BarChartGroupData(
//                                           x: 1,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Bills'] ?? 0,
//                                               width: 16,
//                                               color: Colors.green,
//                                             ),
//                                           ],
//                                         ),
//                                         BarChartGroupData(
//                                           x: 2,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Entertainment'] ?? 0,
//                                               width: 16,
//                                               color: Colors.orange,
//                                             ),
//                                           ],
//                                         ),
//                                         BarChartGroupData(
//                                           x: 3,
//                                           barsSpace: 8,
//                                           barRods: [
//                                             BarChartRodData(
//                                               fromY: 0,
//                                               toY: categoryTotalExpenses['Food'] ?? 0,
//                                               width: 16,
//                                               color: Colors.red,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                       titlesData: FlTitlesData(
//                                         leftTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                             reservedSize: 44,
//                                             showTitles: true,
//                                           ),
//                                         ),
//                                         bottomTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                             reservedSize: 30,
//                                             showTitles: true,
//                                             getTitlesWidget: (double value, TitleMeta meta) {
//                                               switch (value.toInt()) {
//                                                 case 0:
//                                                   return Text('Savings', style: TextStyle(fontSize: 10));
//                                                 case 1:
//                                                   return Text('Bills', style: TextStyle(fontSize: 10));
//                                                 case 2:
//                                                   return Text('Entertainment', style: TextStyle(fontSize: 10));
//                                                 case 3:
//                                                   return Text('Food', style: TextStyle(fontSize: 10));
//                                                 default:
//                                                   return Container();
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

















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

          // Calculate total budget for each category based on the monthly income and percentage
          categoryTotalBudget = {
            'Savings': (_plan!.monthly_income * (_plan!.savings / 100)),
            'Bills': (_plan!.monthly_income * (_plan!.bills / 100)),
            'Entertainment': (_plan!.monthly_income * (_plan!.entertainment / 100)),
            'Food': (_plan!.monthly_income * (_plan!.food / 100)),
          };

          // Initialize remaining balance based on the budget
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

        // Add each expense to the total expenses map
        categoryTotalExpenses[category] = categoryTotalExpenses[category]! + amount;

        // Subtract each expense from the remaining balance map
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
      appBar: AppBar(title: Text("Progress")),
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
                    SizedBox(height: 16),
                    _buildRemainingBalance(plan),
                    SizedBox(height: 16),
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
                  return Text('Error fetching expenses: ${expensesSnapshot.error}', style: TextStyle(fontSize: 16));
                } else if (!expensesSnapshot.hasData) {
                  return Text('No expenses data available', style: TextStyle(fontSize: 16));
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
                        color: Colors.orange,
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
