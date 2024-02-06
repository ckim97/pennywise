// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/first_page.dart';
// import 'package:flutter_application_1/pages/expenses.dart';
// import 'package:flutter_application_1/pages/plan.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FirstPage(),
//       routes: {
//         '/firstpage': (context) => FirstPage(),
//         '/expensespage': (context) => ExpensePage(),
//         '/planpage': (context) => PlanPage(),
//       },
      
//     );
//   }
// }

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
            Icon(Icons.money),
            Icon(Icons.home),
            Icon(Icons.circle),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Handle navigation based on index here
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/expensespage');
                break;
              case 1:
                Navigator.pushNamed(context, '/firstpage');
                break;
              case 2:
                Navigator.pushNamed(context, '/planpage');
                break;
            }
          },
        ),
      ),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/expensespage': (context) => ExpensePage(),
        '/planpage': (context) => PlanPage(),
      },
    );
  }

  Widget _buildBody() {
    // Depending on the selected index, return the corresponding page.
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
