import 'package:bizzvest/my_profile/screens/ProfilePage.dart';
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
      home: MyProfile(),
    ));
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   //list of widgets to call ontap
//   final _widgetOptions = [
//     new LoginForm(),
//     new SignupForm(),
//     new LoginForm(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var x = 2;
//     CookieRequest request = Provider.of<CookieRequest>(context);
//     if (!request.loggedIn) {
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text("BizzVest"),
//           backgroundColor: Colors.blue,
//           actions: <Widget>[
//             Theme(
//               data: Theme.of(context).copyWith(
//                   textTheme: TextTheme().apply(bodyColor: Colors.black),
//                   dividerColor: Colors.white,
//                   iconTheme: IconThemeData(color: Colors.white)),
//               child: PopupMenuButton<int>(
//                 icon: Icon(Icons.account_circle_outlined),
//                 color: Colors.white,
//                 itemBuilder: (context) =>
//                 [
//                   PopupMenuItem<int>(value: 0, child: Text("Login")),
//                   PopupMenuDivider(),
//                   PopupMenuItem<int>(value: 1, child: Text("Sign Up")),
//                 ],
//                 onSelected: (item) => SelectedItem(context, item),
//               ),
//             ),
//           ],
//         ),
//         body: Center(
//           child: _widgetOptions.elementAt(_selectedIndex),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: [
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.list_alt),
//                 title: Text('Daftar Toko'),
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 title: Text('Home'),
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.question_answer),
//                 title: Text('FAQ'),
//                 backgroundColor: Colors.blue),
//           ],
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text("BizzVest"),
//           backgroundColor: Colors.blue,
//           actions: <Widget>[
//             Theme(
//               data: Theme.of(context).copyWith(
//                   textTheme: TextTheme().apply(bodyColor: Colors.black),
//                   dividerColor: Colors.white,
//                   iconTheme: IconThemeData(color: Colors.white)),
//               child: PopupMenuButton<int>(
//                 icon: Icon(Icons.account_circle_outlined),
//                 color: Colors.white,
//                 itemBuilder: (context) =>
//                 [
//                   PopupMenuItem<int>(value: 0, child: Text("Profil")),
//                   PopupMenuItem<int>(value: 1, child: Text("Tambah Toko")),
//                   PopupMenuItem<int>(value: 2, child: Text("Status Investasi")),
//                   PopupMenuDivider(),
//                   PopupMenuItem<int>(value: 3, child: Text("Log Out")),
//                 ],
//                 onSelected: (item) => SelectedItemLogged(context, item),
//               ),
//             ),
//           ],
//         ),
//         body: Center(
//           child: _widgetOptions.elementAt(_selectedIndex),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: [
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.list_alt),
//                 title: Text('Daftar Toko'),
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 title: Text('Home'),
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.question_answer),
//                 title: Text('FAQ'),
//                 backgroundColor: Colors.blue),
//           ],
//         ),
//       );
//     }
//   }

//   void SelectedItem(BuildContext context, item) {
//     switch (item) {
//       case 0:
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => MyProfile()));
//         break;
//       case 1:
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => SignupForm()));
//         break;
//     }
//   }

//   Future<void> SelectedItemLogged(BuildContext context, item) async {
//     final request = context.read<CookieRequest>();
//     switch (item) {
//       case 0:
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => LoginForm()));
//         break;
//       case 1:
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => SignupForm()));
//         break;
//       case 2:
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => SignupForm()));
//         break;
//       case 3:
//         final isLogged = await request.logoutAccount("http://localhost:8000/start-web/logout-flutter");
//         if(isLogged["status"]) {
//           setState((){
//             request.loggedIn = false;
//           });
//         }
//     }
//   }
// }
