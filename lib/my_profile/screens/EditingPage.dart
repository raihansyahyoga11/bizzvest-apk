import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'dart:ui';

import 'package:bizzvest/my_profile/screens/ProfilePage.dart';
import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../widgets/profile.dart';
import '../widgets/text_field.dart';
import '../widgets/app_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';




class EditingPage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<EditingPage>

    with SingleTickerProviderStateMixin {
      final namaLengkap = TextEditingController();
      final username = TextEditingController();
      final jenisKelamin = TextEditingController();
      final email= TextEditingController();
      final NoHandphone= TextEditingController();
      final alamat= TextEditingController();
      final deskripsi = TextEditingController();
      
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath:  'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80',
                  isEdit: true,
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Nama Lengkap',
                  text: 'aselole',
                  onChanged: (nama_lengkap) {},
                ),

                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Username',
                  text: 'uyogie',
                  onChanged: (username) {},
                ),

                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Jenis Kelamin',
                  text: 'Laki-laki',
                  onChanged: (jenis_kelamin) {},
                ),

                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Email',
                  text: 'raihansyahyoga@gmail.com',
                  onChanged: (email) {},
                ),

                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Nomor Handphone',
                  text: '08947432978',
                  onChanged: (phone_number) {},
                ),

                  const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'alamat',
                  text: 'Jalan radikus makan kakus',
                  onChanged: (alamat) {},
                ),

                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Deskripsi diri',
                  text: 'aku adalah para pemenang idola cilik paling ceria serta mulia',
                  maxLines: 5,
                  onChanged: (deskripsi_diri) {},
                ),
              !_status ? _getActionButtons() : new Container()],
            ),
          );
        
    

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
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
                    onPressed: () => setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        showDialog <Void> (context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                    title: const Text('Selamat!'),
                    content: const Text('Profil telah tersimpan'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Navigator.pop(context);
                           Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                              });
                         }),
                         
                    
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
}