import 'package:cats/Account%20Screen/account.dart';
import 'package:cats/Application%20Screen/history.dart';
import 'package:flutter/material.dart';
import 'add_record.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  int _currentTab = 0;

  //Seçili Sayfayı Seçme Init İşlemleri
  @override
  void initState() {
    super.initState();
    _currentTab = 0;
    _pageController = PageController(initialPage: _currentTab);
  }

  //Seçili Sayfayı Seçme Dispose İşlemleri
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIcon(int index, IconData iconData, String text) {
    bool isSelected = index == _currentTab;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isSelected ? 50 : 40,
            height: isSelected ? 50 : 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue[700] : Colors.transparent,
            ),
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : Colors.black,
              size: 30,
            ),
          ),
          Text(text,
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        children: [
          HistoryScreen(),
          AddRecord(),
          AccountScreen(),
        ],
        physics:
            NeverScrollableScrollPhysics(), // Sayfa geçişlerini kontrol etmek için
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIcon(0, Icons.history, 'History'),
          _buildIcon(1, Icons.add, 'Add Record'),
          _buildIcon(2, Icons.account_circle_outlined, 'Account'),
        ],
      ),
    );
  }
}
