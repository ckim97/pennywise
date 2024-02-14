import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_1/pages/first_page.dart';
import 'package:flutter_application_1/pages/expenses.dart';
import 'package:flutter_application_1/pages/plan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("PennyWise"),
        ),
        body: _buildBody(),
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          index: _currentIndex,
          items: [
            Icon(Icons.post_add),
            Icon(Icons.bar_chart_sharp),
            Icon(Icons.edit_note),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            
            switch (index) {
              case 0:
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExpensePage()));
                break;
              case 1:
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FirstPage()));
                break;
              case 2:
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlanPage()));
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    
    switch (_currentIndex) {
      case 0:
        return ExpensePage();
      case 1:
        return FirstPage();
      case 2:
        return PlanPage();
      default:
        return Container();
    }
  }
}