
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';
// import 'package:fl_chart/fl_chart.dart';

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
//   late Future<Plan> _planFuture;
//   late Future<List<dynamic>> _expensesFuture;
//   late Plan _plan; // Declare _plan as a member variable

//   @override
//   void initState() {
//     super.initState();
//     _planFuture = _fetchPlan();
//     _expensesFuture = _fetchExpenses();
//   }

//   Future<Plan> _fetchPlan() async {
//     try {
//       final result = await apiService.get('plans/1');
//       final planData = result;
//       setState(() {
//         _plan = Plan(
//           monthly_income: planData['monthly_income'],
//           savings: planData['savings'],
//           bills: planData['bills'],
//           entertainment: planData['entertainment'],
//           food: planData['food'],
//         );
//       });
//       return _plan;
//     } catch (e) {
//       print('Yo Error fetching plan: $e');
//       rethrow;
//     }
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
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               FutureBuilder<Plan>(
//                 future: _planFuture,
//                 builder: (context, planSnapshot) {
//                   if (planSnapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else if (planSnapshot.hasError) {
//                     return Text('Error fetching plan: ${planSnapshot.error}');
//                   } else if (!planSnapshot.hasData) {
//                     return Text('No plan data available');
//                   } else {
//                     final plan = planSnapshot.data!;

//                     return Card(
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
//                     );
//                   }
//                 },
//               ),
//               SizedBox(height: 16),
//               FutureBuilder<List<dynamic>>(
//                 future: _expensesFuture,
//                 builder: (context, expensesSnapshot) {
//                   if (expensesSnapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else if (expensesSnapshot.hasError) {
//                     return Text('Error fetching expenses: ${expensesSnapshot.error}');
//                   } else if (!expensesSnapshot.hasData) {
//                     return Text('No expenses data available');
//                   } else {
//                     final expenses = expensesSnapshot.data!;

//                     Map<String, double> categoryTotalExpenses = {};

//                     for (var expense in expenses) {
//                       final category = expense.category;
//                       final amount = expense.amount.toDouble();

//                       categoryTotalExpenses[category] = (categoryTotalExpenses[category] ?? 0.0) + amount;
//                     }

//                     return Column(
//                       children: [
//                         Card(
//                           elevation: 5,
//                           margin: EdgeInsets.all(16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Text('Expenses:'),
//                                 for (var category in categoryTotalExpenses.keys)
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Category: $category'),
//                                       Text('Total Amount: \$${categoryTotalExpenses[category]!.toStringAsFixed(2)}'),
//                                       SizedBox(height: 8),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         if (_plan != null) // Check if _plan is not null before using it
//                           Container(
//                             height: 300, // Adjust the height according to your needs
//                             child: BarChart(
//                               BarChartData(
//                                 alignment: BarChartAlignment.center,
//                                 groupsSpace: 40,
//                                 barGroups: [
//                                   BarChartGroupData(
//                                     x: 0,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Savings'] ?? 0,
//                                         width: 16,
//                                         color: Colors.blue,
//                                       ),
//                                     ],
//                                   ),
//                                   BarChartGroupData(
//                                     x: 1,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Bills'] ?? 0,
//                                         width: 16,
//                                         color: Colors.green,
//                                       ),
//                                     ],
//                                   ),
//                                   BarChartGroupData(
//                                     x: 2,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Entertainment'] ?? 0,
//                                         width: 16,
//                                         color: Colors.orange,
//                                       ),
//                                     ],
//                                   ),
//                                   BarChartGroupData(
//                                     x: 3,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Food'] ?? 0,
//                                         width: 16,
//                                         color: Colors.red,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                                 titlesData: FlTitlesData(
//                                   leftTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       reservedSize: 44,
//                                       showTitles: true,
//                                     ),
//                                   ),
//                                   bottomTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       reservedSize: 30,
//                                       showTitles: true,
//                                       getTitlesWidget: (double value, TitleMeta meta) {
//                                         switch (value.toInt()) {
//                                           case 0:
//                                             return Text('Savings', style: TextStyle(fontSize: 10));
//                                           case 1:
//                                             return Text('Bills', style: TextStyle(fontSize: 10));
//                                           case 2:
//                                             return Text('Entertainment', style: TextStyle(fontSize: 10));
//                                           case 3:
//                                             return Text('Food', style: TextStyle(fontSize: 10));
//                                           default:
//                                             return Container(); // Return an empty container or another default widget if needed
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


















/// this one is the good one// 


// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';
// import 'package:fl_chart/fl_chart.dart';

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
//   late Future<Plan> _planFuture;
//   late Future<List<dynamic>> _expensesFuture;
//   late Plan _plan; // Declare _plan as a member variable

//   @override
//   void initState() {
//     super.initState();
//     _planFuture = _fetchPlan();
//     _expensesFuture = _fetchExpenses();
//   }

//   Future<Plan> _fetchPlan() async {
//     try {
//       final result = await apiService.get('plans/1');
//       final planData = result;

//       if (planData == null) {
//         setState(() {
//           _plan = Plan(
//             monthly_income: 0,
//             savings: 0,
//             bills: 0,
//             entertainment: 0,
//             food: 0,
//           );
//         });
//       } else {
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

//       return _plan;
//     } catch (e) {
//       print('Yo Error fetching plan: $e');
//       rethrow;
//     }
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
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               FutureBuilder<Plan>(
//                 future: _planFuture,
//                 builder: (context, planSnapshot) {
//                   if (planSnapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else if (planSnapshot.hasError) {
//                     return Text('Error fetching plan: ${planSnapshot.error}');
//                   } else if (!planSnapshot.hasData || _plan.monthly_income == 0) {
//                     return Text('Please enter a plan.');
//                   } else {
//                     final plan = planSnapshot.data!;

//                     return Card(
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
//                     );
//                   }
//                 },
//               ),
              
//               FutureBuilder<List<dynamic>>(
//                 future: _expensesFuture,
//                 builder: (context, expensesSnapshot) {
//                   if (expensesSnapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else if (expensesSnapshot.hasError) {
//                     return Text('Error fetching expenses: ${expensesSnapshot.error}');
//                   } else if (!expensesSnapshot.hasData) {
//                     return Text('No expenses data available');
//                   } else {
//                     final expenses = expensesSnapshot.data!;

//                     Map<String, double> categoryTotalExpenses = {};

//                     for (var expense in expenses) {
//                       final category = expense.category;
//                       final amount = expense.amount.toDouble();

//                       categoryTotalExpenses[category] = (categoryTotalExpenses[category] ?? 0.0) + amount;
//                     }

//                     return Column(
//                       children: [
//                         Card(
//                           elevation: 5,
//                           margin: EdgeInsets.all(16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Text('Expenses:'),
//                                 for (var category in categoryTotalExpenses.keys)
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Category: $category'),
//                                       Text('Total Amount: \$${categoryTotalExpenses[category]!.toStringAsFixed(2)}'),
//                                       SizedBox(height: 8),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         if (_plan != null && _plan.monthly_income != 0)
//                           Container(
//                             height: 300,
//                             child: BarChart(
//                               BarChartData(
//                                 alignment: BarChartAlignment.center,
//                                 groupsSpace: 40,
//                                 barGroups: [
//                                   BarChartGroupData(
//                                     x: 0,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Savings'] ?? 0,
//                                         width: 16,
//                                         color: Colors.blue,
//                                       ),
//                                     ],
//                                   ),
//                                   BarChartGroupData(
//                                     x: 1,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Bills'] ?? 0,
//                                         width: 16,
//                                         color: Colors.green,
//                                       ),
//                                     ],
//                                   ),
//                                   BarChartGroupData(
//                                     x: 2,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Entertainment'] ?? 0,
//                                         width: 16,
//                                         color: Colors.orange,
//                                       ),
//                                     ],
//                                   ),
//                                   BarChartGroupData(
//                                     x: 3,
//                                     barsSpace: 8,
//                                     barRods: [
//                                       BarChartRodData(
//                                         fromY: 0,
//                                         toY: categoryTotalExpenses['Food'] ?? 0,
//                                         width: 16,
//                                         color: Colors.red,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                                 titlesData: FlTitlesData(
//                                   leftTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       reservedSize: 44,
//                                       showTitles: true,
//                                     ),
//                                   ),
//                                   bottomTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       reservedSize: 30,
//                                       showTitles: true,
//                                       getTitlesWidget: (double value, TitleMeta meta) {
//                                         switch (value.toInt()) {
//                                           case 0:
//                                             return Text('Savings', style: TextStyle(fontSize: 10));
//                                           case 1:
//                                             return Text('Bills', style: TextStyle(fontSize: 10));
//                                           case 2:
//                                             return Text('Entertainment', style: TextStyle(fontSize: 10));
//                                           case 3:
//                                             return Text('Food', style: TextStyle(fontSize: 10));
//                                           default:
//                                             return Container();
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }














import 'package:flutter/material.dart';
import 'package:flutter_application_1/fetch_requests.dart';
import 'package:fl_chart/fl_chart.dart';

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
  late Plan? _plan; // Declare _plan as a nullable member variable

  @override
  void initState() {
    super.initState();
    _planFuture = _fetchPlan();
    _expensesFuture = _fetchExpenses();
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
        });
      }

      return _plan;
    } catch (e) {
      print('Error fetching plan: $e');
      setState(() {
        _plan = null; // Set _plan to null in case of an error
      });
      rethrow;
    }
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<Plan?>(
                future: _planFuture,
                builder: (context, planSnapshot) {
                  if (planSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (planSnapshot.hasError || planSnapshot.data == null) {
                    // Do not display anything here, as we want to handle the error silently
                    return SizedBox.shrink();
                  } else {
                    final plan = planSnapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 5,
                          margin: EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Monthly Income: \$${plan.monthly_income.toStringAsFixed(2)}'),
                                Text('Savings: ${plan.savings.toInt()}%'),
                                Text('Bills: ${plan.bills.toInt()}%'),
                                Text('Entertainment: ${plan.entertainment.toInt()}%'),
                                Text('Food: ${plan.food.toInt()}%'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        FutureBuilder<List<dynamic>>(
                          future: _expensesFuture,
                          builder: (context, expensesSnapshot) {
                            if (expensesSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (expensesSnapshot.hasError) {
                              return Text('Error fetching expenses: ${expensesSnapshot.error}');
                            } else if (!expensesSnapshot.hasData) {
                              return Text('No expenses data available');
                            } else {
                              final expenses = expensesSnapshot.data!;

                              Map<String, double> categoryTotalExpenses = {};

                              for (var expense in expenses) {
                                final category = expense.category;
                                final amount = expense.amount.toDouble();

                                categoryTotalExpenses[category] =
                                    (categoryTotalExpenses[category] ?? 0.0) + amount;
                              }

                              return Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text('Expenses:'),
                                          for (var category in categoryTotalExpenses.keys)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Category: $category'),
                                                Text(
                                                    'Total Amount: \$${categoryTotalExpenses[category]!.toStringAsFixed(2)}'),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  if (_plan != null && _plan!.monthly_income != 0)
                                    Container(
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
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return Text('Savings', style: TextStyle(fontSize: 10));
                                                    case 1:
                                                      return Text('Bills', style: TextStyle(fontSize: 10));
                                                    case 2:
                                                      return Text('Entertainment', style: TextStyle(fontSize: 10));
                                                    case 3:
                                                      return Text('Food', style: TextStyle(fontSize: 10));
                                                    default:
                                                      return Container();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
