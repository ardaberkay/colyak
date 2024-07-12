import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colyak/utils/colors.dart';
import 'package:colyak/views/screens/mymealpage.dart';
import 'package:colyak/views/screens/reportpage.dart';
import 'package:colyak/views/screens/homepage.dart';
import 'package:colyak/views/screens/profilepage.dart';
import 'package:colyak/views/screens/receiptpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent, // Burada scaffold arka planını şeffaf yapıyoruz
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const AllReceiptsPage(),
    const MyMealPage(),
    const ReportPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: AppColors.mainColor,
        notchMargin: 6.0,
        child: Container(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.home, size: 30),
                  onPressed: () {
                    _onItemTapped(0);
                  },
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey[350]
              ),
              IconButton(
                  icon: const Icon(Icons.restaurant, size: 30),
                  onPressed: () {
                    _onItemTapped(1);
                  },
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey[350]
              ),
              SizedBox(width: 30),
              IconButton(
                  icon: const Icon(Icons.receipt_long, size: 30),
                  onPressed: () {
                    _onItemTapped(3);
                  },
                  color: _selectedIndex == 3 ? Colors.white : Colors.grey[350]
              ),
              IconButton(
                  icon: const Icon(Icons.person, size: 30),
                  onPressed: () {
                    _onItemTapped(4);
                  },
                  color: _selectedIndex == 4 ? Colors.white : Colors.grey[350]
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            _onItemTapped(2);
          },
          backgroundColor: AppColors.mainColor, shape: const CircleBorder(),
          child: Icon(Icons.add_outlined, size: 32, color: _selectedIndex == 2 ? Colors.white : Colors.grey[350]),
        ),
      ),
    );
  }
}
