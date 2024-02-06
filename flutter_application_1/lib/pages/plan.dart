import 'package:flutter/material.dart';
import 'package:flutter_application_1/fetch_requests.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController savingsController = TextEditingController();
  TextEditingController billsController = TextEditingController();
  TextEditingController entertainmentController = TextEditingController();
  TextEditingController foodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Plan")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryField('Monthly Income', incomeController),
              _buildCategoryField('Percent Allocation for Savings', savingsController),
              _buildCategoryField('Percent Allocation for Bills', billsController),
              _buildCategoryField('Percent Allocation for Entertainment', entertainmentController),
              _buildCategoryField('Percent Allocation for Food', foodController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Handle button press, save data, etc.
                  // For example, you can print the values for now
                  final apiService = ApiService('http://localhost:5555');

                  final planData = {
                    'monthly_income': incomeController.text,
                    'savings': savingsController.text,
                    'bills': billsController.text,
                    'entertainment': entertainmentController.text,
                    'food': foodController.text,
                    'user_id' : 1,
                  };

                  try {
                    final result = await apiService.post('plans', planData);
                  } catch (e) {
                      print('Failed to save plan: $e');
                  }




                  print('Monthly Income: ${incomeController.text}');
                  print('Savings: ${savingsController.text}');
                  print('Bills: ${billsController.text}');
                  print('Entertainment: ${entertainmentController.text}');
                  print('Food: ${foodController.text}');
                },
                child: Text('Save Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
