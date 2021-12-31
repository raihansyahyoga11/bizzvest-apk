import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/foundation.dart';
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
        () async {
      await request.init(context);
    }();
    return Scaffold(
      backgroundColor: Color(0xffdafcff),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Signup Page"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 400,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Username'),
                    onChanged: (String? value) {
                      setState(() {
                        username = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Alamat Email'),
                    onChanged: (String? value) {
                      setState(() {
                        email = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
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
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Konfirmasi Password'),
                    onChanged: (String? value) {
                      setState(() {
                        confirmPassword = value!;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
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
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () async {
                        if (username == "" || email == "" ||  password == "" || confirmPassword == "") {
                          final snackBar = SnackBar(
                              content: const Text(
                                  'Isi username dan password anda')
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (_formKey.currentState!.validate()) {
                      final response = await request.post(
                          NETW_CONST.get_server_URL("/start-web/signup-flutter"), {
                            'username': username,
                            'email': email,
                            'password': password,
                          });
                      if (response['status'] == 'username exist') {
                        final snackBar = SnackBar(
                            content: const Text('Username telah terpakai. Masukkan username lain')
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (response['status'] == 'invalid format') {
                        final snackBar = SnackBar(
                            content: const Text(
                                'Mauskkan email dengan format yang benar')
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (response['status'] == 'email exist') {
                        final snackBar = SnackBar(
                            content: const Text(
                                'Email telah terpakai. Masukkan username lain')
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (response['status'] == 'authenticated') {
                        final loggingIn = await request
                            .login(NETW_CONST.get_server_URL("/start-web/login-flutter"), {
                          'username': username,
                          'password': password,
                        });
                        if (loggingIn['status']) {
                          if (!kIsWeb){
                            set_authentication(request.cookies[COOKIE_CONST.session_id_cookie_name]!);
                          }
                          Navigator.pop(context);
                        }
                      } else {
                        final snackBar = SnackBar(
                            content: const Text(
                                'Ada Kesalahan')
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
