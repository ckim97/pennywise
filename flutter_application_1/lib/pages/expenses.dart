// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';


// class ExpenseEntry {
//   String category;
//   String description;
//   double amount;
//   int plan_id;

//   ExpenseEntry({
//     required this.category,
//     required this.description,
//     required this.amount,
//     required this.plan_id,
//   });
// }

// class ExpensePage extends StatefulWidget {
//   @override
//   _ExpensePageState createState() => _ExpensePageState();
// }

// class _ExpensePageState extends State<ExpensePage> {
//   List<ExpenseEntry> expenses = [];
//   String selectedCategory = 'Savings';
//   TextEditingController amountController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('E X P E N S E S'),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCategoryDropdown('Category', selectedCategory),
//               _buildTextField('Description', descriptionController),
//               _buildAmountField('Amount', amountController),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   addExpense();
//                 },
//                 child: Text('Add Expense'),
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: expenses.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       child: ListTile(
//                         title: Text('Category: ${expenses[index].category}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Description: ${expenses[index].description}'),
//                             Text('Amount: \$${expenses[index].amount.toString()}'),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown(String label, String selectedValue) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 8),
//         DropdownButton<String>(
//           value: selectedCategory,
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedCategory = newValue!;
//             });
//           },
//           items: ['Savings', 'Entertainment', 'Bills', 'Food']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildAmountField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   void addExpense() async {
//   double amount = double.tryParse(amountController.text) ?? 0.0;
//   if (amount > 0) {
//     ExpenseEntry newExpense = ExpenseEntry(
//       category: selectedCategory,
//       description: descriptionController.text,
//       amount: amount,
//       plan_id: 1, // REPLACE LATER 
//     );

//     final apiService = ApiService('http://localhost:5555'); 

//     final newExpenseEntry = {
//         'category': newExpense.category,
//         'description': newExpense.description,
//         'amount': newExpense.amount,
//         'plan_id': newExpense.plan_id,
//       };

    
//     try {
//         final result = await apiService.post('expenses', newExpenseEntry);
//         print(result);  // Print the response for inspection
//         setState(() {
//           expenses.add(newExpense);
//           amountController.clear();
//           descriptionController.clear();
//           print(expenses);
//           expenses.forEach((expense) {
//             print('Category: ${expense.category}, Description: ${expense.description}, Amount: ${expense.amount}, Plan ID: ${expense.plan_id}');
// });
//         });

//     } catch (e) {
//       print('Failure to Add Expense: $e');
//     }
//     // try {
//     //   final result = await apiService.post('expenses', newExpenseEntry);
//     //    print(result);  // Print the response for inspection
      
//     //   if (result['success'] == true) {
//     //     // If the server responds with success, add the expense to the local list
//         // setState(() {
//         //   expenses.add(newExpense);
//         //   amountController.clear();
//         //   descriptionController.clear();
//         //   print(expenses);
//         // });
//     //   } else {
//     //     // Handle server response indicating failure
//     //     print('Failed to add expense. Server response: ${result['message']}');
//     //   }
//     // } catch (e) {
//     //   // Handle network or other errors here
//     //   print('Failed to add expense: $e');
//     // }
//   }
// }


// }


import 'package:flutter/material.dart';
import 'package:flutter_application_1/fetch_requests.dart';

class ExpenseEntry {
  String category;
  String description;
  double amount;
  int plan_id;

  ExpenseEntry({
    required this.category,
    required this.description,
    required this.amount,
    required this.plan_id,
  });
}

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<ExpenseEntry> expenses = [];
  String selectedCategory = 'Savings';
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    final apiService = ApiService('http://localhost:5555');
    try {
      final result = await apiService.get('expenses/1');
      if (result != null && result['expenses'] != null) {
        setState(() {
          expenses = (result['expenses'] as List<dynamic>)
              .map<ExpenseEntry>((expenseData) => ExpenseEntry(
                    category: expenseData['category'] ?? '',
                    description: expenseData['description'] ?? '',
                    amount: (expenseData['amount'] as num?)?.toDouble() ?? 0.0,
                    plan_id: expenseData['plan_id'] ?? 0,
                  ))
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('E X P E N S E S'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryDropdown('Category', selectedCategory),
              _buildTextField('Description', descriptionController),
              _buildAmountField('Amount', amountController),
              // SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addExpense();
                },
                child: Text('Add Expense'),
              ),
              // SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('Category: ${expenses[index].category}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${expenses[index].description}'),
                            Text('Amount: \$${expenses[index].amount.toString()}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(String label, String selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 2),
        DropdownButton<String>(
          value: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          items: ['Savings', 'Entertainment', 'Bills', 'Food']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 2),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 2),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }

  Widget _buildAmountField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 2),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }

  void addExpense() async {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount > 0) {
      ExpenseEntry newExpense = ExpenseEntry(
        category: selectedCategory,
        description: descriptionController.text,
        amount: amount,
        plan_id: 1, // REPLACE LATER
      );

      final apiService = ApiService('http://localhost:5555');

      final newExpenseEntry = {
        'category': newExpense.category,
        'description': newExpense.description,
        'amount': newExpense.amount,
        'plan_id': newExpense.plan_id,
      };

      try {
        final result = await apiService.post('expenses', newExpenseEntry);
        print(result); // Print the response for inspection
        setState(() {
          expenses.add(newExpense);
          amountController.clear();
          descriptionController.clear();
          print(expenses);
          expenses.forEach((expense) {
            print(
                'Category: ${expense.category}, Description: ${expense.description}, Amount: ${expense.amount}, Plan ID: ${expense.plan_id}');
          });
        });
      } catch (e) {
        print('Failure to Add Expense: $e');
      }
    }
  }
}
