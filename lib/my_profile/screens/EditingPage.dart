
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
import 'package:bizzvest/halaman_toko/shared/configurations.dart';

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:core';





class EditingPage extends StatefulWidget {
  final String initial_csrf;
  int maxLines;
  String label;
  String text;
    //  late File _image;
 
  GlobalKey<FormState> form_key = GlobalKey<FormState>();

  // final ValueChanged<dynamic> onChanged;
  // String dropdownvalue = 'Pilih jenis kelamin';
  // var items =  ['Laki-laki','Perempuan'];

  EditingPage({
    required this.initial_csrf,
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
  // Future<File> file;
  String status ='';
  UserForm formUser = UserForm();
  FormData formData = FormData();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  GlobalKey<FormState> get form_key{
    return widget.form_key;
  }
  final ImagePicker picker = ImagePicker();
  late String initial_csrf;
  String csrf_token = "";
  var _locations= ['Laki-laki','Perempuan','Pilih jenis kelamin'];
  String _selectedLocation= 'Perempuan';
  XFile? image;
  AutovalidateMode autovalidate = AutovalidateMode.disabled;
  

  //  chooseImage() {
  //   setState(() {
  //     file =ImagePicker.pickImage(source: ImageSource.gallery);

  //   });
  //   setStatus('');
  // }
  @override
  void initState() {
    super.initState();
    csrf_token = widget.initial_csrf;
  }

  Future<bool> savingData() async {
    final validation = form_key.currentState?.validate();
    if (validation != null) {
      if (!validation) {
        return false;
      }
    form_key.currentState?.save();
        showDialog (context: context, 
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
  }
    return true;
  }
 

 Future<void> on_tap_add_photo(BuildContext context) async{
    var auth = await get_authentication(context);
    image = await picker.pickImage(source: ImageSource.gallery);
     if (image == null) {
       show_snackbar(context, "user didnt pick any image");
       return;
     }

     final response = await auth.post(
      uri: Uri.parse('http://10.0.2.2:8000/my-profile/foto-api'), 
    // headers: <String, String> {
    //   'Content-Type':'application/json;charset=UTF-8',
    // },
    data: {
        "photo_profile": await MultipartFile.fromFile(image!.path)
      },
    
    );
    // print(response.reasonPhrase);
    // print(response.body);

      
      // formData.files.add(MapEntry('photo_profile', await MultipartFile.fromFile(image!.path)));
      // formData.fields.add(MapEntry(COOKIE_CONST.csrf_token_formdata,csrf_token));
   }
 
Future<void> submit_to_server(BuildContext context) async{
    // if (!enable_submit_button)
    //   return null;

    var auth = await get_authentication(context);
    final dict;
    // print({"photo_profile": await MultipartFile.fromFile(image!.path)});
    final response = await auth.post(
      uri: Uri.parse('http://10.0.2.2:8000/my-profile/my-profile-json'), 
    // headers: <String, String> {
    //   'Content-Type':'application/json;charset=UTF-8',
    // },
    data: formUser.to_map()
      ..addAll({
        COOKIE_CONST.csrf_token_formdata:csrf_token,
      }),
    
    );
    print(formUser.to_map());
    // print(response.statusCode);
    // print(response.reasonPhrase);
    // print(response.body);
  
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
                      setState(() {
                        
                        // _status = true;
                        // FocusScope.of(context).requestFocus(new FocusNode());
                        savingData();
                        submit_to_server(context);
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



  Widget futureWidgetEdit() {
    return FutureBuilder<User>(
        future: loadUser(context),
        builder: (BuildContext context,AsyncSnapshot<User> snapshot) {
          if(snapshot.hasData) {
            child: return Form(
              key: form_key,
              autovalidateMode: autovalidate,
              child: 
            new ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                children: [
                  ProfileWidget(
                    imagePath:  "http://10.0.2.2:8000/${snapshot.data?.photoProfile}",
                    // isEdit: true,
                    onClicked: () {
                      setState(() {
                         on_tap_add_photo(context);
                      });
                      
                    // getImage().then((String value) {
                    //   // setState(() {
                    //     print(value);
                    //       //  });
                    //   onSaved: (value);
                    //       if (value != null) {
                    //       formUser.photo_profile = value;
                    //       }
                    //   });
                    // value = getImage().toString();
                    // onSaved:(value): 
                    // if (value != null) {
                    //   formUser.photo_profile=value;
                    // }
                      
                    }
                    
                    // getImage();  
                    // Image.file(_image);
                    // print(_image.path);
                    // onSaved: formUser.photo_profile = _image.path;
                    // }
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
                        
                        initialValue: "${snapshot.data?.namaLengkap}",
                        maxLines: widget.maxLines,         
                        onSaved: (value) {
                          if (value != null) {
                          formUser.full_name = value;
                          }
                        },      
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
                            
                      onSaved: (value) {
                        if (value != null) {
                        formUser.username= value;
                        }
                      },
                      )
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
                        new DropdownButtonFormField(
                          // if ("${snapshot.data?.jenisKelamin}".equals("laki_laki") {
                            value: "${snapshot.data?.jenisKelamin}",
                          // }
                          onChanged: (String? newValue) {
                              this._selectedLocation = newValue!;
                            // setState(() {
                          },
                              onSaved: (String? newValue) {  
                                if  (newValue!=null){
                                  if (newValue == "Laki-laki") {
                                      formUser.gender = "laki_laki";
                                  }
                                  else if(newValue == "Perempuan") {
                                    formUser.gender ='perempuan';
                                  }
                                  else {
                                    formUser.gender = "jenis_kelamin";
                                  }
                                }
                          },
                            // });
                          items:_locations.map((String location) =>
                            new DropdownMenuItem<String>(
                              value: location,
                              child: Text(location)
                              )).toList(),
                        )
                        // TextFormField( 
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        //   ),
                        // ),
                        // initialValue: "${snapshot.data?.jenisKelamin}",
                        // maxLines: widget.maxLines,
                        //   onSaved: (value) {
                        //     if (value != null) {
                        //       formUser.gender= value;
                        //     }
                        //   },
                        
                        // ),
                    
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
                        if (!RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value!)) {
                          return "Periksa lagi email yang anda masukkan";
                        }
                      },
                      onSaved: (value) {
                        if (value != null) {
                        formUser.email= value;
                        }
                      },
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
                          // controller: controlPhoneNumber,
                          
                          onSaved: (value) {
                            if (value != null) {
                              formUser.phone_number= value;
                            }
                          },
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
                      // controller: controlAlamat,
                      onSaved: (value) {
                        if (value != null) {
                        formUser.alamat= value;
                        }
                      },
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
                      maxLines: 5,
                      // controller: controlDeskripsi,
                      onSaved: (value) {
                        if (value != null) {
                        formUser.deskripsi_diri= value;
                        }
                      },
                  ),
                  
                    ],
                  ),
                _status? _getActionButtons() : new Container()] ,
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


 @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          // appBar: new AppBar(
          //   title: new Text('Edit Profile'),
          // ),
          body: futureWidgetEdit(),
          // drawer: MainDrawer(),
    )
    );
  }
}
