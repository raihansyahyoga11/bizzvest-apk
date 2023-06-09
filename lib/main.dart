// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:bizzvest/faq/faq.dart';
import 'package:bizzvest/halaman_toko/add_toko/add_toko.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:bizzvest/my_profile/screens/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:bizzvest/login_signup/login.dart';
import 'package:bizzvest/login_signup/signup.dart';
import 'package:bizzvest/home_page/main.dart' as home_page;
import 'package:bizzvest/login_signup/cookie.dart';
import 'package:bizzvest/daftar_toko/screen/daftar_toko.dart';
import 'package:bizzvest/mulai_invest/mulai_invest_screen.dart';
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
        create: (context) {
          CookieRequest request = CookieRequest();
          return request;
        },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizzVest',
      home: MyHomePage(),
      routes: {
        MulaiInvestScreen.routeName: (ctx) => MulaiInvestScreen(),
      }
    ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  bool loggedIn = false;

  //list of widgets to call ontap
  final _widgetOptions = [
    new DaftarTokoMaterial(),  // nanti diisi sama daftar toko
    new home_page.HomePage(),
    new FaqUtamaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuildContextKeeper.main_dart_MaterialApp_context = context;
    CookieRequest request = Provider.of<CookieRequest>(context);

    () async {
      await request.init(context);
      setState(() {
        loggedIn = request.loggedIn;
      });
    }();

    if (!loggedIn) {
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
                itemBuilder: (context) =>
                [
                  PopupMenuItem<int>(value: 0, child: Text("Login"), textStyle: TextStyle(color: Colors.black),),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(value: 1, child: Text("Sign Up"), textStyle: TextStyle(color: Colors.black),),
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
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("BizzVest"),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TextTheme().apply(bodyColor: Colors.black),
                  dividerColor: Colors.black,
                  iconTheme: IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                icon: Icon(Icons.account_circle_outlined),
                color: Colors.white,
                itemBuilder: (context){
                  return [
                    PopupMenuItem<int>(value: 0, child: Text("Profil"), textStyle: TextStyle(color: Colors.black),),
                    PopupMenuItem<int>(value: 1, child: Text("Tambah Toko"), textStyle: TextStyle(color: Colors.black)),
                    // PopupMenuItem<int>(value: 2, child: Text("Status Investasi"), textStyle: TextStyle(color: Colors.black)),
                    PopupMenuDivider(),
                    PopupMenuItem<int>(value: 3, child: Text("Log Out"), textStyle: TextStyle(color: Colors.black)),
                  ];
                },
                onSelected: (item) => SelectedItemLogged(context, item),
              ),
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
  }

  Future<void> SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginForm()));
        setState(() {});
        break;
      case 1:
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignupForm()));
        setState(() {});
        break;
    }
  }

  Future<void> SelectedItemLogged(BuildContext context, item) async {
    final request = context.read<CookieRequest>();
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyProfile()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddToko()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignupForm()));
        break;
      case 3:
        final isLogged = await request.logoutAccount(NETW_CONST.get_server_URL("/start-web/logout-flutter"));
        if(isLogged["status"]) {
          setState((){
            request.loggedIn = false;
          });
        }
    }
  }
}
