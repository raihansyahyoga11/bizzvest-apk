import 'package:flutter/material.dart';
import 'package:bizzvest/login_signup/login.dart';
import 'package:bizzvest/login_signup/signup.dart';
import 'package:bizzvest/login_signup/cookie.dart';
import 'package:provider/provider.dart';


//referensi:
//https://protocoderspoint.com/how-to-create-3-dot-popup-menu-item-on-appbar-flutter/
//https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
//https://www.javatpoint.com/flutter-bottom-navigation-bar

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) {
      CookieRequest request = CookieRequest();

      return request;
    },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizzVest',
      home: MyHomePage(),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Ini Daftar Toko',
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue)),
    Text('Ini Home',
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue)),
    Text('Ini FAQ',
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("BizzVest"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.black),
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              icon: Icon(Icons.account_circle_outlined),
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text("Login")),
                PopupMenuDivider(),
                PopupMenuItem<int>(value: 1, child: Text("Sign Up")),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              title: Text('Daftar Toko'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              title: Text('FAQ'),
              backgroundColor: Colors.blue),
        ],
      ),
    );
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginForm()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignupForm()));
        break;
    }
  }
}
