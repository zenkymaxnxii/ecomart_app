import 'package:flutter/material.dart';
import 'package:ecomart_app/constants.dart';
import '../Pages/profile_page.dart';
import '../Pages/history_order_page.dart';
import '../Pages/home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;
  var pages = const [
    HomePage2(),
    ProfilePage(),
    HistoryOrderPage(),
  ];

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(10),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: Colors.black38,
              selectedLabelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: kPrimaryLightColor,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Trang chủ"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: "Tài khoản"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: "Lịch sử"),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return Future<bool>.value(true);
        },
      );
}
