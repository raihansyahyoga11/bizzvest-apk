import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bizzvest/login_signup/main.dart';
import 'package:bizzvest/login_signup/cookie.dart';
import 'package:provider/provider.dart';

// Referensi: https://levelup.gitconnected.com/login-page-ui-in-flutter-65210e7a6c90
class LoginForm extends StatefulWidget {
  @override
  Login createState() => Login();
}

class Login extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  bool refresh = false;

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    () async {
      await request.init(context);
    }();
    return Scaffold(
      backgroundColor: Color(0xffdafcff),
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          //   child: Container(
          // padding: const EdgeInsets.all(0.0),
          // height: 250,
          // alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
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
                    // onSaved: (String? value) {
                    //   setState(() {
                    //     username = value!;
                    //   });
                    // },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password'),
                    onChanged: (String? value) {
                      setState(() {
                        password = value!;
                      });
                    },
                    // onSaved: (String? value) {
                    //   setState(() {
                    //     password = value!;
                    //   });
                    // },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () async {
                        if (username == "" || password == "") {
                          final snackBar = SnackBar(
                              content: const Text(
                                  'Isi username dan password anda')
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final response = await request
                              .login(NETW_CONST.get_server_URL(
                              "/start-web/login-flutter"),
                              {
                                'username': username,
                                'password': password,
                              }
                          );

                          if (response['status']) {
                            if (!kIsWeb){
                              set_authentication(request.cookies[COOKIE_CONST.session_id_cookie_name]!);
                            }
                            Navigator.pop(context);
                          } else {
                            final snackBar = SnackBar(
                                content: const Text(
                                    'Username atau password anda salah, silahkan coba lagi')
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                      },
                      child: Text(
                        'Masuk',
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
