
//testing phase //




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

  ApiService apiService = ApiService('http://localhost:5555');
  int userId = 1; // Hardcoded user id for now

  @override
  void initState() {
    super.initState();
    checkExistingPlan();
  }

  Future<void> checkExistingPlan() async {
    try {
      final result = await apiService.get('plans/$userId');
      if (result != null) {
        setState(() {
          incomeController.text = result['monthly_income']?.toString() ?? '';
          savingsController.text = result['savings']?.toString() ?? '';
          billsController.text = result['bills']?.toString() ?? '';
          entertainmentController.text = result['entertainment']?.toString() ?? '';
          foodController.text = result['food']?.toString() ?? '';
        });
      }
    } catch (e) {
      print('Failed to fetch plan: $e');
    }
  }

  Future<void> updatePlan(Map<String, dynamic> updatedPlanData) async {
    final endpoint = 'plans/$userId';

    try {
      final response = await apiService.patch(endpoint, updatedPlanData);

      if (response.containsKey('errors')) {
        print('Failed to update plan. Errors: ${response['errors']}');
      } else {
        print('Plan updated successfully');
        checkExistingPlan(); // Refresh the plan after update
      }
    } catch (e) {
      print('Exception during plan update: $e');
    }
  }

  Future<void> deletePlan() async {
    final endpoint = 'plans/$userId';

    try {
      await apiService.delete(endpoint);
      print('Plan deleted successfully');

      // Clear the existing plan details
      setState(() {
        incomeController.text = '';
        savingsController.text = '';
        billsController.text = '';
        entertainmentController.text = '';
        foodController.text = '';
      });

      // Show a snackbar to indicate successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plan deleted successfully'),
        ),
      );

      setState(() {});
      checkExistingPlan();
      _buildPlanForm();

    } catch (e) {
      print('Exception during plan deletion: $e');
    }
  }








  Widget _buildPageContent() {
    // Check if any of the controllers has a non-empty value
    if (incomeController.text.isNotEmpty ||
        savingsController.text.isNotEmpty ||
        billsController.text.isNotEmpty ||
        entertainmentController.text.isNotEmpty ||
        foodController.text.isNotEmpty) {
      return _buildPlanView();
    } else {
      return _buildPlanForm();
    }
  }

  Widget _buildPlanView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Plan:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _buildEditablePlanDetail('Monthly Income', incomeController),
        _buildEditablePlanDetail('Savings', savingsController),
        _buildEditablePlanDetail('Bills', billsController),
        _buildEditablePlanDetail('Entertainment', entertainmentController),
        _buildEditablePlanDetail('Food', foodController),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final updatedPlanData = {
                  'monthly_income': incomeController.text,
                  'savings': savingsController.text,
                  'bills': billsController.text,
                  'entertainment': entertainmentController.text,
                  'food': foodController.text,
                };

                await updatePlan(updatedPlanData);
              },
              child: Text('Update Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                deletePlan();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Delete Plan'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditablePlanDetail(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150, // Set a fixed width for the category labels
            child: Text(
              label + ':',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            width: 150, // Set a fixed width for the text boxes
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryField('Monthly Income', incomeController),
        _buildCategoryField('Percent Allocation for Savings', savingsController),
        _buildCategoryField('Percent Allocation for Bills', billsController),
        _buildCategoryField(
            'Percent Allocation for Entertainment', entertainmentController),
        _buildCategoryField('Percent Allocation for Food', foodController),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            final planData = {
              'monthly_income': incomeController.text,
              'savings': savingsController.text,
              'bills': billsController.text,
              'entertainment': entertainmentController.text,
              'food': foodController.text,
              'user_id': userId,
            };

            try {
              await apiService.post('plans', planData);
              checkExistingPlan(); // Refresh the plan after submission
            } catch (e) {
              print('Failed to save plan: $e');
            }
          },
          child: Text('Save Plan'),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Plan"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _buildPageContent(),
        ),
      ),
    );
  }
}
