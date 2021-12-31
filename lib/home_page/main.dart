import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(HomeApp());

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final _messageFormKey = GlobalKey<FormState>();
    
    String email = "";
    String message = "";
    // perlu ganti URL-nya sesuai server django
    String apiURL = "http://192.168.42.66:8002/save-api/";
    // urlku aneh2 karena pake usb ke hp :)

    final TextEditingController _emailController = new TextEditingController();
    final TextEditingController _messageController = new TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("Homepage")),
            body: Container(
                color: Color(0xffdafcff),
                child: ListView(
                    padding: EdgeInsets.all(24),
                    children: <Widget>[
                        Image.asset('src/img/front-image-small.png'),
                        Text(
                            'BizzVest, Solusi untuk Perkembangan Bisnis Anda di Masa Pandemi COVID-19',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1, 
                                fontSize: 36, 
                                color: Color(0xff0096c7),
                            ),
                        ),
                        Text(
                            'Tetap produktif di masa pandemi COVID-19 dengan BizzVest, karena BizzVest hadir sebagai jalan keluar bagi pelaku bisnis seperti pemilik UMKM (Usaha Mikro, Kecil, dan Menengah) dan petani untuk mendapatkan modal usaha dari para investor agar dapat melanjutkan bisnis mereka.',
                            style: TextStyle(
                                fontSize: 18,
                            ),
                        ),
                        SizedBox(height: 40,),
                        Text(
                            'Konsultasikan Kebutuhanmu dengan Tim BizzVest!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xff0096c7),
                            ),
                        ),
                        Form(
                            key:_messageFormKey,
                            child: Container(
                                child: Column(
                                    children: [
                                        TextFormField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                                labelText:'Email',
                                                hintText:'Masukkan email',
                                            ),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Email tidak boleh kosong';
                                                }
                                                return null;
                                            },
                                        ),
                                        TextFormField(
                                            controller: _messageController,
                                            decoration: InputDecoration(
                                                labelText:'Pesan',
                                                hintText:'Masukkan pesan',
                                            ),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Tulis pesan kamu!';
                                                }
                                                return null;
                                            },
                                        ),
                                        RaisedButton(
                                            onPressed: () async{
                                                if (_messageFormKey.currentState!.validate()) {
                                                    email = _emailController.text;
                                                    message = _messageController.text;
                                                    final response = await http.post(
                                                        Uri.parse(apiURL),
                                                        headers: <String, String>{
                                                            'Content-Type': 'application/json; charset=UTF-8'
                                                        },
                                                        body: jsonEncode(<String, String>{
                                                            'email': email,
                                                            'message': message,
                                                        })
                                                    );
                                                    print(response);
                                                    print(response.body);
                                                    setState(() {
                                                        _emailController.clear();
                                                        _messageController.clear();
                                                    });
                                                    return showDialog(
                                                        context: context,
                                                        builder: (ctx) => AlertDialog(
                                                            title: Text("Pesan Terkirim"),
                                                            content: Text("Pesan kamu sudah terkirim!"),
                                                            actions: <Widget>[
                                                                FlatButton(
                                                                    onPressed: () {
                                                                        Navigator.of(ctx).pop();
                                                                    },
                                                                    child: Text("OK"),
                                                                ),
                                                            ],
                                                        ),
                                                    );
                                                }
                                            },
                                            child: Text(
                                              "Kirim Pesan",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            color: Colors.blue,
                                        ),
                                    ],
                                ),
                            )
                        ),
                    ],
                ),
            ),
        );
    }
}
