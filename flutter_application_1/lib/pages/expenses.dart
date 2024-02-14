
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';

// class ExpenseEntry {
//   String category;
//   String description;
//   double amount;
//   int id; 
//   int plan_id;

//   ExpenseEntry({
//     required this.category,
//     required this.description,
//     required this.amount,
//     required this.id,
//     required this.plan_id,
//   });

//   @override
//   String toString() {
//     return 'ExpenseEntry{id: $id, category: $category, description: $description, amount: $amount, plan_id: $plan_id}';
//   }
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
//   TextEditingController editAmountController = TextEditingController();
//   TextEditingController editDescriptionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadExpenses();
//   }

//   Future<void> _loadExpenses() async {
//     List<ExpenseEntry> fetchedExpenses = await _fetchExpenses();
//     setState(() {
//       expenses = fetchedExpenses;
//     });
//   }

//   Future<List<ExpenseEntry>> _fetchExpenses() async {
//     final apiService = ApiService('http://localhost:5555');
//     try {
//       final result = await apiService.get('expenses/1');
//       if (result != null && result['expenses'] != null) {
//         return (result['expenses'] as List<dynamic>)
//             .map<ExpenseEntry>((expenseData) => ExpenseEntry(
//                   category: expenseData['category'] ?? '',
//                   description: expenseData['description'] ?? '',
//                   amount: (expenseData['amount'] as num?)?.toDouble() ?? 0.0,
//                   id: expenseData['id'] ?? 0,
//                   plan_id: expenseData['plan_id'] ?? 0,
//                 ))
//             .toList();
//       }
//     } catch (e) {
//       print('Error fetching expenses: $e');
//     }
//     return []; 
//   }

//   Future<ExpenseEntry?> _fetchExpenseById(int id) async {
//     final apiService = ApiService('http://localhost:5555');
//     try {
//       final result = await apiService.get('expense/$id');
//       if (result != null) {
//         print('result is: $result');
//         ExpenseEntry expense = ExpenseEntry(
//           category: result['category'] ?? '',
//           description: result['description'] ?? '',
//           amount: (result['amount'] as num?)?.toDouble() ?? 0.0,
//           id: result['id'] ?? 0,
//           plan_id: result['plan_id'] ?? 0,
//         );

//         print('Fetched Expense: $expense');

//         return expense;
//       }
//     } catch (e) {
//       print('AAAYURRR Error fetching expense by ID: $e');
//     }
//     print('null');
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('E X P E N S E S'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildCategoryDropdown('Category', selectedCategory),
//             _buildTextField('Description', descriptionController),
//             _buildAmountField('Amount', amountController),
//             ElevatedButton(
//               onPressed: () {
//                 addExpense();
//               },
//               child: Text('Add Expense'),
//             ),
//             _buildExpenseList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown(String label, String selectedValue) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 2),
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
//         SizedBox(height: 2),
//       ],
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 2),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 2),
//       ],
//     );
//   }

//   Widget _buildAmountField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 2),
//         TextFormField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 2),
//       ],
//     );
//   }

//   Widget _buildExpenseList() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: expenses.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Category: ${expenses[index].category}'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${expenses[index].description}'),
//                   Text('Amount: \$${expenses[index].amount.toString()}'),
//                 ],
//               ),
//               trailing: IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () {
//                   print(expenses[index]);
//                   editExpense(expenses[index]);
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void addExpense() async {
//     double amount = double.tryParse(amountController.text) ?? 0.0;
//     if (amount > 0) {
//       ExpenseEntry newExpense = ExpenseEntry(
//         category: selectedCategory,
//         description: descriptionController.text,
//         amount: amount,
//         id: 0, 
//         plan_id: 1,
//       );

//       final apiService = ApiService('http://localhost:5555');

//       final newExpenseEntry = {
//         'category': newExpense.category,
//         'description': newExpense.description,
//         'amount': newExpense.amount,
//         'id': newExpense.id,
//         'plan_id': newExpense.plan_id,
//       };

//       try {
//         final result = await apiService.post('expenses', newExpenseEntry);
//         print(result); 
//         setState(() {
//           expenses.add(newExpense);
//           amountController.clear();
//           descriptionController.clear();
//         });
//       } catch (e) {
//         print('Failure to Add Expense: $e');
//       }
//     }
//   }

//   void editExpense(ExpenseEntry expense) async {
   
//     final individualExpense = await _fetchExpenseById(expense.id);
//     print('Individual Expense: $individualExpense');

//     if (individualExpense != null) {
      
//       editAmountController.text = individualExpense.amount.toString();
//       editDescriptionController.text = individualExpense.description;

     
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Edit Expense'),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildCategoryDropdown('Category', individualExpense.category),
//                 _buildTextField('Description', editDescriptionController),
//                 _buildAmountField('Amount', editAmountController),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context); 
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () async {
                  
//                   await updateExpense(expense);
                 
//                   await _loadExpenses();
//                   Navigator.pop(context); 
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
      
//       print('YURRR Failed to fetch individual expense for ID: ${expense.id}');
//     }
//   }

//   Future<void> updateExpense(ExpenseEntry expense) async {
//     final apiService = ApiService('http://localhost:5555');

//     final updatedExpenseEntry = {
//       'category': selectedCategory, 
//       'description': editDescriptionController.text,
//       'amount': double.tryParse(editAmountController.text) ?? 0.0,
//       'plan_id': expense.plan_id,
//     };

//     try {
//       final result = await apiService.patch('patchexpenses/${expense.id}', updatedExpenseEntry);
//       print(result); 
//     } catch (e) {
//       print('Failure to Update Expense: $e');
     
//     }
//   }
// }




// working delete // 

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/fetch_requests.dart';

// class ExpenseEntry {
//   String category;
//   String description;
//   double amount;
//   int id;
//   int plan_id;

//   ExpenseEntry({
//     required this.category,
//     required this.description,
//     required this.amount,
//     required this.id,
//     required this.plan_id,
//   });

//   @override
//   String toString() {
//     return 'ExpenseEntry{id: $id, category: $category, description: $description, amount: $amount, plan_id: $plan_id}';
//   }
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
//   TextEditingController editAmountController = TextEditingController();
//   TextEditingController editDescriptionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadExpenses();
//   }

//   Future<void> _loadExpenses() async {
//     List<ExpenseEntry> fetchedExpenses = await _fetchExpenses();
//     setState(() {
//       expenses = fetchedExpenses;
//     });
//   }

//   Future<List<ExpenseEntry>> _fetchExpenses() async {
//     final apiService = ApiService('http://localhost:5555');
//     try {
//       final result = await apiService.get('expenses/1');
//       if (result != null && result['expenses'] != null) {
//         return (result['expenses'] as List<dynamic>)
//             .map<ExpenseEntry>((expenseData) => ExpenseEntry(
//                   category: expenseData['category'] ?? '',
//                   description: expenseData['description'] ?? '',
//                   amount: (expenseData['amount'] as num?)?.toDouble() ?? 0.0,
//                   id: expenseData['id'] ?? 0,
//                   plan_id: expenseData['plan_id'] ?? 0,
//                 ))
//             .toList();
//       }
//     } catch (e) {
//       print('Error fetching expenses: $e');
//     }
//     return [];
//   }

//   Future<ExpenseEntry?> _fetchExpenseById(int id) async {
//     final apiService = ApiService('http://localhost:5555');
//     try {
//       final result = await apiService.get('expense/$id');
//       if (result != null) {
//         print('result is: $result');
//         ExpenseEntry expense = ExpenseEntry(
//           category: result['category'] ?? '',
//           description: result['description'] ?? '',
//           amount: (result['amount'] as num?)?.toDouble() ?? 0.0,
//           id: result['id'] ?? 0,
//           plan_id: result['plan_id'] ?? 0,
//         );

//         print('Fetched Expense: $expense');

//         return expense;
//       }
//     } catch (e) {
//       print('AAAYURRR Error fetching expense by ID: $e');
//     }
//     print('null');
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('E X P E N S E S'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildCategoryDropdown('Category', selectedCategory),
//             _buildTextField('Description', descriptionController),
//             _buildAmountField('Amount', amountController),
//             ElevatedButton(
//               onPressed: () {
//                 addExpense();
//               },
//               child: Text('Add Expense'),
//             ),
//             _buildExpenseList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown(String label, String selectedValue) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 2),
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
//         SizedBox(height: 2),
//       ],
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 2),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 2),
//       ],
//     );
//   }

//   Widget _buildAmountField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         SizedBox(height: 2),
//         TextFormField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 2),
//       ],
//     );
//   }

//   Widget _buildExpenseList() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: expenses.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Category: ${expenses[index].category}'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${expenses[index].description}'),
//                   Text('Amount: \$${expenses[index].amount.toString()}'),
//                 ],
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () {
//                       print(expenses[index]);
//                       editExpense(expenses[index]);
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       deleteExpense(expenses[index].id);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void addExpense() async {
//     double amount = double.tryParse(amountController.text) ?? 0.0;
//     if (amount > 0) {
//       ExpenseEntry newExpense = ExpenseEntry(
//         category: selectedCategory,
//         description: descriptionController.text,
//         amount: amount,
//         id: 0,
//         plan_id: 1,
//       );

//       final apiService = ApiService('http://localhost:5555');

//       final newExpenseEntry = {
//         'category': newExpense.category,
//         'description': newExpense.description,
//         'amount': newExpense.amount,
//         'id': newExpense.id,
//         'plan_id': newExpense.plan_id,
//       };

//       try {
//         final result = await apiService.post('expenses', newExpenseEntry);
//         print(result);
//         setState(() {
//           expenses.add(newExpense);
//           amountController.clear();
//           descriptionController.clear();
//         });
//       } catch (e) {
//         print('Failure to Add Expense: $e');
//       }
//     }
//   }

//   void editExpense(ExpenseEntry expense) async {
//     final individualExpense = await _fetchExpenseById(expense.id);
//     print('Individual Expense: $individualExpense');

//     if (individualExpense != null) {
//       editAmountController.text = individualExpense.amount.toString();
//       editDescriptionController.text = individualExpense.description;

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Edit Expense'),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildCategoryDropdown(
//                     'Category', individualExpense.category),
//                 _buildTextField(
//                     'Description', editDescriptionController),
//                 _buildAmountField('Amount', editAmountController),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   await updateExpense(expense);
//                   await _loadExpenses();
//                   Navigator.pop(context);
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print(
//           'YURRR Failed to fetch individual expense for ID: ${expense.id}');
//     }
//   }

//   Future<void> updateExpense(ExpenseEntry expense) async {
//     final apiService = ApiService('http://localhost:5555');

//     final updatedExpenseEntry = {
//       'category': selectedCategory,
//       'description': editDescriptionController.text,
//       'amount': double.tryParse(editAmountController.text) ?? 0.0,
//       'plan_id': expense.plan_id,
//     };

//     try {
//       final result = await apiService.patch(
//           'patchexpenses/${expense.id}', updatedExpenseEntry);
//       print(result);
//     } catch (e) {
//       print('Failure to Update Expense: $e');
//     }
//   }
  
  
//   void deleteExpense(int id) async {
//     final apiService = ApiService('http://localhost:5555');
//     try {
//       await apiService.delete('expenses/$id');
//     } catch (e) {
//       print('Failure to Delete Expense: $e');
//     }

    
//     await _loadExpenses();
//   }




// }







import 'package:flutter/material.dart';
import 'package:flutter_application_1/fetch_requests.dart';

class ExpenseEntry {
  String category;
  String description;
  double amount;
  int id;
  int plan_id;

  ExpenseEntry({
    required this.category,
    required this.description,
    required this.amount,
    required this.id,
    required this.plan_id,
  });

  @override
  String toString() {
    return 'ExpenseEntry{id: $id, category: $category, description: $description, amount: $amount, plan_id: $plan_id}';
  }
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
  TextEditingController editAmountController = TextEditingController();
  TextEditingController editDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    List<ExpenseEntry> fetchedExpenses = await _fetchExpenses();
    setState(() {
      expenses = fetchedExpenses;
    });
  }

  Future<List<ExpenseEntry>> _fetchExpenses() async {
    final apiService = ApiService('http://localhost:5555');
    try {
      final result = await apiService.get('expenses/1');
      if (result != null && result['expenses'] != null) {
        return (result['expenses'] as List<dynamic>)
            .map<ExpenseEntry>((expenseData) => ExpenseEntry(
                  category: expenseData['category'] ?? '',
                  description: expenseData['description'] ?? '',
                  amount: (expenseData['amount'] as num?)?.toDouble() ?? 0.0,
                  id: expenseData['id'] ?? 0,
                  plan_id: expenseData['plan_id'] ?? 0,
                ))
            .toList();
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    }
    return [];
  }

  Future<ExpenseEntry?> _fetchExpenseById(int id) async {
    final apiService = ApiService('http://localhost:5555');
    try {
      final result = await apiService.get('expense/$id');
      if (result != null) {
        print('result is: $result');
        ExpenseEntry expense = ExpenseEntry(
          category: result['category'] ?? '',
          description: result['description'] ?? '',
          amount: (result['amount'] as num?)?.toDouble() ?? 0.0,
          id: result['id'] ?? 0,
          plan_id: result['plan_id'] ?? 0,
        );

        print('Fetched Expense: $expense');

        return expense;
      }
    } catch (e) {
      print('AAAYURRR Error fetching expense by ID: $e');
    }
    print('null');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E X P E N S E S'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryDropdown('Category', selectedCategory),
            _buildTextField('Description', descriptionController),
            _buildAmountField('Amount', amountController),
            ElevatedButton(
              onPressed: () {
                addExpense();
              },
              child: Text('Add Expense'),
            ),
            _buildExpenseList(),
          ],
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

  Widget _buildExpenseList() {
    return Expanded(
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
                  Text('Amount: \$${expenses[index].amount.toStringAsFixed(2)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      print(expenses[index]);
                      editExpense(expenses[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteExpense(expenses[index].id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void addExpense() async {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount > 0) {
      ExpenseEntry newExpense = ExpenseEntry(
        category: selectedCategory,
        description: descriptionController.text,
        amount: amount,
        id: 0,
        plan_id: 1,
      );

      final apiService = ApiService('http://localhost:5555');

      final newExpenseEntry = {
        'category': newExpense.category,
        'description': newExpense.description,
        'amount': newExpense.amount,
        'id': newExpense.id,
        'plan_id': newExpense.plan_id,
      };

      try {
        final result = await apiService.post('expenses', newExpenseEntry);
        print(result);

        // Update the state by adding the new expense directly
        setState(() {
          expenses.add(newExpense); // Insert at the beginning of the list
          amountController.clear();
          descriptionController.clear();
        });
      } catch (e) {
        print('Failure to Add Expense: $e');
      }
    }
  }




  void editExpense(ExpenseEntry expense) async {
    final individualExpense = await _fetchExpenseById(expense.id);
    print('Individual Expense: $individualExpense');

    if (individualExpense != null) {
      editAmountController.text = individualExpense.amount.toString();
      editDescriptionController.text = individualExpense.description;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Expense'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCategoryDropdown(
                    'Category', individualExpense.category),
                _buildTextField(
                    'Description', editDescriptionController),
                _buildAmountField('Amount', editAmountController),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await updateExpense(expense);
                  await _loadExpenses();
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    } else {
      print(
          'YURRR Failed to fetch individual expense for ID: ${expense.id}');
    }
  }

  Future<void> updateExpense(ExpenseEntry expense) async {
    final apiService = ApiService('http://localhost:5555');

    final updatedExpenseEntry = {
      'category': selectedCategory,
      'description': editDescriptionController.text,
      'amount': double.tryParse(editAmountController.text) ?? 0.0,
      'plan_id': expense.plan_id,
    };

    try {
      final result = await apiService.patch(
          'patchexpenses/${expense.id}', updatedExpenseEntry);
      print(result);
    } catch (e) {
      print('Failure to Update Expense: $e');
    }
  }
  
  
  void deleteExpense(int id) async {
    final apiService = ApiService('http://localhost:5555');
    try {
      await apiService.delete('expenses/$id');
    } catch (e) {
      print('Failure to Delete Expense: $e');
    }

    
    await _loadExpenses();
  }




}
