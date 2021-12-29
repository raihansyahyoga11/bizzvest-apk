import 'dart:ffi';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:bizzvest/my_profile/widgets/UserForm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'dart:ui';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'dart:async' show Future;

import 'package:bizzvest/my_profile/screens/ProfilePage.dart';
import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../widgets/profile.dart';
import '../widgets/text_field.dart';
import '../widgets/app_bar.dart';
import '../models/UserAccount.dart';
import 'ProfilePage.dart';
import '../api/api_my_profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';




class EditingPage extends StatefulWidget {
  int maxLines;
  String label;
  String text;
  GlobalKey<FormState> form_key = GlobalKey<FormState>();

  // final ValueChanged<dynamic> onChanged;
  String dropdownvalue = 'Pilih jenis kelamin';
  var items =  ['Laki-laki','Perempuan'];

  EditingPage({
    Key? key,
    this.maxLines = 1,
    this.label="",
    this.text="",
    // required this.onChanged,
  }) : super(key: key);

  @override
  EditingScreenState createState() => EditingScreenState();
}




class EditingScreenState extends State<EditingPage> {

  late final controlNamaLengkap = TextEditingController();
  UserForm formUser = UserForm();
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  GlobalKey<FormState> get form_key{
    return widget.form_key;
  }

  @override
  void initState() {
    super.initState();
  // controlNamaLengkap.addListener(UserForm().nama_lengkap = '${controlNamaLengkap.text}')
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Edit Profile'),
          ),
          body: futureWidgetEdit(),
          drawer: MainDrawer(),
    )
    );
  }



  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Simpan"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () async{
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        submit_to_server(context);
                        


                        showDialog <Void> (context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Selamat!'),
                                  content: const Text('Profil telah tersimpan'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              });
                         },
                         
                    
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Batalkan"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () => 
                    
                    Navigator.pop(context),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

Future<void> submit_to_server(BuildContext context) async{
    // if (!enable_submit_button)
    //   return null;

    // var auth = await get_authentication();
    // var dict = UserForm().to_map();
    final response = await http.post(Uri.parse('http://10.0.2.2:8000/my-profile/my-profile-api'),
    headers: <String, String> {
      'Content-Type':'application/json;charset=UTF-8',
    },
    body: jsonEncode(UserForm().to_map())
    );
    // print(response);
    print(response.body);
}


Widget futureWidgetEdit() {
   return FutureBuilder<User>(
      future: loadUser(),
      builder: (context,snapshot) {
        if(snapshot.hasData) {
          child: return Form(
            key: form_key,
            child: 
           new ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath:  'https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80',
                  isEdit: true,
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Nama Lengkap',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    
                    // initialValue: "${snapshot.data?.namaLengkap}",
                    maxLines: widget.maxLines,
                    controller: controlNamaLengkap,
                    // validator: (value) {
                    // }          
                    onChanged: (String value) async {
                      UserForm().nama_lengkap= value;
                    }
                    
              
                      

                      
                ),
                 
                  ],
                ),
               

                const SizedBox(height: 24),
            new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Username',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                      
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: "${snapshot.data?.username}",
                    maxLines: widget.maxLines,
                    validator: (value) {
                      if(value != null) {
                      onSaved: UserForm().user_name= value;
                      }
                    }
                ),
                 
                  ],
                ),

                const SizedBox(height: 24),
               new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Jenis Kelamin',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                      
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: "${snapshot.data?.jenisKelamin}",
                    maxLines: widget.maxLines,
                    validator: (value) {
                      if(value != null) {
                      onSaved: UserForm().jenis_kelamin = value;
                      }
                    }
                ),
                 
                  ],
                ),

                const SizedBox(height: 24),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                      
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: "${snapshot.data?.email}",
                    maxLines: widget.maxLines,
                    validator: (value) {
                      if(value != null) {
                      onSaved: UserForm().e_mail = value;
                      }
                    }
                ),
                 
                  ],
                ),

                const SizedBox(height: 24),
               new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Nomor Telepon',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                      
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: "${snapshot.data?.nomorTelepon}",
                    maxLines: widget.maxLines,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value != null) {
                      onSaved: UserForm().nomor_telepon= int.parse(value);
                      }
                    }
                ),
                 
                  ],
                ),

                  const SizedBox(height: 24),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Alamat',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                      
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: "${snapshot.data?.alamat}",
                    maxLines: widget.maxLines,
                    validator: (value) {
                      if(value != null) {
                      onSaved: UserForm().alamat_saya = value;
                      }
                    }
                ),
                 
                  ],
                ),

                const SizedBox(height: 24),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ='Deskripsi diri',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
                      
                    ),
                    const SizedBox(height: 8),
                    TextFormField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialValue: "${snapshot.data?.deskripsi}",
                    maxLines: widget.maxLines,
                    validator: (value) {
                      if(value != null) {
                      onSaved: UserForm().deskripsi_saya = value;
                      }
                    }
                ),
                 
                  ],
                ),
              !_status ? _getActionButtons() : new Container()],
            )
          );
        }
         else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      }
   );
}
}