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

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.white,
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
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password'),
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
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () async {
                        final response = await request
                            .login("http://localhost:8000/start-web/login-flutter", {
                          'username': username,
                          'password': password,
                        });
                        if (response['status']) {
                          Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => MyHomePage()));
                        }
                        // if (_formKey.currentState?.validate() ?? true) {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (_) => MyHomePage()));
                        // }
                      },
                      child: Text(
                        'Masuk',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Belum Punya Akun? Daftar Disini')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
