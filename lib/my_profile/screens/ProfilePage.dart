import 'dart:ui';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'dart:async' show Future;
import 'EditingPage.dart';
import '../models/UserAccount.dart';
import '../api/api_my_profile.dart';
import '../widgets/main_drawer.dart';
import 'package:bizzvest/main.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

 


void main() {
  runApp(MyProfile());
}

class MyProfile extends StatefulWidget {
  MyProfile();
  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
    Widget _getEditIcon(AsyncSnapshot<dynamic> snapshot) {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
      ),
      onTap: () {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditingPage(initial_csrf: "${snapshot.data?.csrfToken}"),
            ));
        // setState(() {
        //   _status = false;
        // });
      },
    );
  }
      
  final bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  // void getReq() async {
  //     final response = await http.get(Uri.parse("http://10.0.2.2:8000/my-profile/my-profile-json"),headers: <String, String>{'Content-Type':'application/json'});
  //     print(response.body);
  //   }

  Widget futureWidget() {
    return new FutureBuilder<User>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Container(
            color: Colors.white,
            child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 330,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding (
                          padding: EdgeInsets.only(top:30, left:25, right:220, bottom:0),
                          child: new ElevatedButton(
                            style: ButtonStyle(
    elevation: MaterialStateProperty.resolveWith<double?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed))
          return 16;
        return null;
      }),
  ),
  onPressed: () { 
    Navigator.pop(context);
  },
  child: Text('Kembali ke Halaman Utama'),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:0, left:220, right:25, bottom:20),
                            // child: Container(
                            //   child: Center(
                                child:  Builder(
                                  builder: (context){
                                    if (snapshot.data?.investor == true && snapshot.data?.enterpreneur == true) {
                                                   return new Column(children: <Widget> [
                                          Container(
                                            width: 100,
                                            height: 30,
                                            decoration: new BoxDecoration(
                                              color: Colors.green[600],
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              
                                              ),
                                              child:Align(
                                                alignment: Alignment.center,
                                                  child: Text(
                                                    'Enterpreneur',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                      ),
                                                    ) ,
                                                  )
                                          ),   
                                          
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            width: 75,
                                            height: 30,
                                            decoration: new BoxDecoration(
                                              color: Colors.blue[800],
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              
                                              ),
                                              child:Align(
                                                alignment: Alignment.center,
                                                  child: Text(
                                                    'Investor',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                      ),
                                                    ) ,
                                                  )
                                        ),   

                                          // ],)
                                      ],);
                                  
                                      
                                    }
                                    else if (snapshot.data?.investor==true) {
                                      return Container(
                                          width: 90,
                                          height: 30,
                                          decoration: new BoxDecoration(
                                            color: Colors.blue[800],
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(10),
                                            
                                            ),
                                            child:Align(
                                              alignment: Alignment.center,
                                                child: Text(
                                                  'Investor',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                    ),
                                                    
                                                  ) ,
                                                )
                                      );
                                    }
                                    else if (snapshot.data?.enterpreneur==true) {
                                      return Container(
                                            width: 90,
                                            height: 30,
                                            decoration: new BoxDecoration(
                                              color: Colors.green[600],
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              
                                              ),
                                              child:Align(
                                                alignment: Alignment.center,
                                                  child: Text(
                                                    'Enterpreneur',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                      ),
                                                    ) ,
                                                  )
                                          );   
        
                                         
                                    }
                                    else {
                                        return Container(
                                          width: 90,
                                          height: 30,
                                          decoration: new BoxDecoration(
                                            color: Colors.yellow[800],
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(10),
                                            
                                            ),
                                            child:Align(
                                              alignment: Alignment.center,
                                                child: Text(
                                                  'Not Verified',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                    ),
                                                    
                                                  ) ,
                                                )
                                      );
                        
                                    }
                                  })
                              
                            ,
            
                            ),
                        
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new NetworkImage(
                                            "${NETW_CONST.protocol}${NETW_CONST.host}/${snapshot.data?.photoProfile}"),   
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                  
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 25.0,
                                      child: _getEditIcon(snapshot)
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),

                  new Container(
                    // padding: EdgeInsets.only(top: -50),
                    child: Text('${snapshot.data?.namaLengkap}',
                            style: 
                            TextStyle(fontSize: 20),),
                  ),

                  new Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10,bottom: 30),
                      child:Text('@${snapshot.data?.username}'),
                    )
                  ),

                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[


                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Nama lengkap',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                  color: Colors.blue)
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new Text(
                                        "${snapshot.data?.namaLengkap}",
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ]
                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Username',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          
                              Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Text(
                                     "${snapshot.data?.username}",
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Jenis kelamin',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                  color: Colors.blue)
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Text(
                                     "${snapshot.data?.jenisKelamin}",
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Text(
                                      "${snapshot.data?.email}"
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Nomor Handphone',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Text(
                                   "${snapshot.data?.nomorTelepon}"
                                    ),
                                  ),
                                ],
                              )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Alamat',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new Text(
                               "${snapshot.data?.alamat}"
                                ),
                              ),
                            ],
                          )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Deskripsi',
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Text(
                                      "${snapshot.data?.deskripsi}"
                                    ),
                                  ),
                                ],
                              )),
                          // !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          
           
            
            
        ),);
        } 
        else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BuildContextKeeper.my_profile_context = context;
    return new MaterialApp(
      
      home: new Scaffold(
          // appBar: new AppBar(

          //   title: new Text('My Profile'),
          // ),
          body: futureWidget(),
          // drawer: MainDrawer(),
      )
    );
    
  }
}