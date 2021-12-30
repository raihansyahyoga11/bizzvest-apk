import 'package:flutter/material.dart';

// import '../screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
        children: <Widget>[
          Container(
            height: 130,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Daftar Toko",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
            ),
          ),
          Container(
            height:  MediaQuery.of(context).size.height-130,
            color: Color.fromRGBO(242, 255, 253, 1),
            child: Column(
              children: <Widget>[
              buildListTile('Main Menu', Icons.square_foot_rounded, () {}),
              buildListTile('Daftar Toko', Icons.shop, (){}),
              buildListTile('FAQ', Icons.question_answer, (){})
                ] ,
            ),
          ),
          
        ],
      ),
      
    );
  }
}
