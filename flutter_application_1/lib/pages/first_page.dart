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

// class FirstPage extends StatefulWidget {
//   const FirstPage({Key? key}) : super(key: key);

//   @override
//   _FirstPageState createState() => _FirstPageState();
// }

// class _FirstPageState extends State<FirstPage> {
//   final ApiService apiService = ApiService('http://localhost:5555');
//   late Future<Plan> _planFuture;
  

//   @override
//   void initState() {
//     super.initState();
//     _planFuture = _fetchPlan();
//   }

//   Future<Plan> _fetchPlan() async {
//     try {
//       final result = await apiService.get('plans/1');
//       print(result);
//       final planData = result; // Adjust based on your API response structure
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

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text("Progress")),
//     body: Align(
//       alignment: Alignment.topCenter,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<Plan>(
//           future: _planFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData) {
//               return Text('No plan data available');
//             } else {
//               final plan = snapshot.data!;

//               return Card(
//                 elevation: 5,
//                 margin: EdgeInsets.all(16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text('Monthly Income: \$${plan.monthly_income.toStringAsFixed(2)}'),
//                       Text('Savings: ${plan.savings.toInt()}%'),
//                       Text('Bills: ${plan.bills.toInt()}%'),
//                       Text('Entertainment: ${plan.entertainment.toInt()}%'),
//                       Text('Food: ${plan.food.toInt()}%'),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     ),
//   );
// }



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
  final String name;
  final double amount;
  final String category;

  Expense({
    required this.name,
    required this.amount,
    required this.category,
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
  late Future<List<Expense>> _expensesFuture;

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

  Future<List<Expense>> _fetchExpenses() async {
  try {
    final result = await apiService.get('expenses/1');
    print(result); 

    final List<dynamic> expensesData = result; 

    // Convert the data to a list of Expense objects
    final List<Expense> expenses = expensesData
        .map((expenseData) => Expense(
              name: expenseData['name'],
              amount: expenseData['amount'],
              category: expenseData['category'],
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
              FutureBuilder<List<Expense>>(
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
                            for (var expense in expenses)
                              Text('${expense.name}: \$${expense.amount.toStringAsFixed(2)}'),
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
