// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';

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
//       return Plan(
//         monthly_income: planData['monthly_income'],
//         savings: planData['savings'],
//         bills: planData['bills'],
//         entertainment: planData['entertainment'],
//         food: planData['food'],
//       );
//     } catch (e) {
//       print('Error fetching plan: $e');
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
//                 amount: expenseData['amount'],
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
//       body: Align(
//         alignment: Alignment.topCenter,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
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
//               SizedBox(height: 16), // Add some space between plan and expenses
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

//                     return Card(
//                       elevation: 5,
//                       margin: EdgeInsets.all(16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text('Expenses:'),
//                             for (var expense in expenses)
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Category: ${expense.category}'),
//                                   Text('Description: ${expense.description}'),
//                                   Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
//                                   SizedBox(height: 8),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ),
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
  late Future<Plan> _planFuture;
  late Future<List<dynamic>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _planFuture = _fetchPlan();
    _expensesFuture = _fetchExpenses();
  }

  Future<Plan> _fetchPlan() async {
    try {
      final result = await apiService.get('plans/1');
      final planData = result;
      return Plan(
        monthly_income: planData['monthly_income'],
        savings: planData['savings'],
        bills: planData['bills'],
        entertainment: planData['entertainment'],
        food: planData['food'],
      );
    } catch (e) {
      print('Error fetching plan: $e');
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder<Plan>(
                future: _planFuture,
                builder: (context, planSnapshot) {
                  if (planSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (planSnapshot.hasError) {
                    return Text('Error fetching plan: ${planSnapshot.error}');
                  } else if (!planSnapshot.hasData) {
                    return Text('No plan data available');
                  } else {
                    final plan = planSnapshot.data!;

                    return Card(
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
                    );
                  }
                },
              ),
              SizedBox(height: 16), // Add some space between plan and expenses
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

                  // Create a map to store total expenses for each category
                  Map<String, double> categoryTotalExpenses = {};

                  // Calculate total expenses for each category
                  for (var expense in expenses) {
                    final category = expense.category;
                    final amount = expense.amount.toDouble();

                    categoryTotalExpenses[category] = (categoryTotalExpenses[category] ?? 0.0) + amount;
                  }

                  return Card(
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
                                Text('Total Amount: \$${categoryTotalExpenses[category]!.toStringAsFixed(2)}'),
                                SizedBox(height: 8),
                              ],
                            ),
                        ],
                      ),
                    ),
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