import 'package:flutter/material.dart';
import 'package:bizzvest/login_signup/main.dart';
import 'package:bizzvest/login_signup/cookie.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

// Referensi: https://levelup.gitconnected.com/login-page-ui-in-flutter-65210e7a6c90
class SignupForm extends StatefulWidget {
  @override
  Signup createState() => Signup();
}

class Signup extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();

  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Signup Page"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 125, 0, 0),
            // height: 250,
            // alignment: Alignment.center,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Username'),
                    onChanged: (String? value) {
                      setState(() {
                        username = value!;
                      });
                    },
                    onSaved: (String? value) {
                      setState(() {
                        username = value!;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Username tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  // padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Alamat Email'),
                    onChanged: (String? value) {
                      setState(() {
                        email = value!;
                      });
                    },
                    onSaved: (String? value) {
                      setState(() {
                        email = value!;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Alamat Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password'),
                    controller: _pass,
                    onChanged: (String? value) {
                      setState(() {
                        password = value!;
                      });
                    },
                    onSaved: (String? value) {
                      setState(() {
                        password = value!;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Konfirmasi Password'),
                    onChanged: (String? value) {
                      setState(() {
                        confirmPassword = value!;
                      });
                    },
                    onSaved: (String? value) {
                      setState(() {
                        confirmPassword = value!;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Konfirmasi password tidak boleh kosong';
                      }
                      if (value != _pass.text) {
                        return "Password tidak sama";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.post(
                          "http://http://127.0.0.1:8000/start-web/signup-flutter", {
                            'username': username,
                            'email': email,
                            'password': password,
                          });
                      if (response['status']) {
                        final loggingIn = await request
                            .login(
                            "http://http://127.0.0.1:8000/start-web/login-flutter", {
                          'username': username,
                          'password': password,
                        });
                        if (loggingIn['status']) {
                          Navigator.pop(context);
                        }
                      }
                    }
                      },
                      child: Text(
                        'Daftar',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Sudah Punya Akun? Masuk Disini')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
