import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bizzvest',
      theme: ThemeData(   //Theme
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ),
      ),
      home: const MyHomePage(title: 'Bizzvest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  //int _counter = 0;

  //void _incrementCounter() {
  //  setState(() {
  //    _counter++;
  //  });
  //}

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
            const Padding(//positioning
                padding: EdgeInsets.all(12.0),
                child: Text(    //basic widget
                    'BizzVest, Solusi untuk Perkembangan Bisnis Anda di Masa Pandemi COVID-19',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1, 
                        fontSize: 36, 
                        color: Color(0xff0096c7)
                    ),//naiss
                ),
            ),
            Form(
                key: _formKey,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                        children: [
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    hintText: "Masukkan email yang bisa dihubungi",
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(5.0)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    hintText: "Masukkan pesan",
                                    labelText: "Pesan",
                                    border: OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(5.0)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tulis pesan kamu!';
                                    }
                                    return null;
                                  },
                                ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: RaisedButton(
                                  child: Text(
                                    "Kirim Pesan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.blue,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                        print("Berhasil mengirim pesan!");
                                    }
                                  },
                                ),
                            ),
                            //
                        ],
                    ),
                ),
            ),
            //Container(
            //    height: 100,
            //    width: 100,
            //    color: Colors.blue,
            //),
            //Container(
            //    height: 100,
            //    width: 100,
            //    color: Colors.green,
            //),
        ],
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _incrementCounter,
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
