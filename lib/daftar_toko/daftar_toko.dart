import 'package:flutter/material.dart';

import 'widgets/main_drawer.dart';
import './toko_data.dart';
import './models/toko.dart';

void main() {
  runApp(MyApp());
}

List<CustomCard> getTokoWidget(List<Toko> daftarToko){
  List<CustomCard> list = [];
  for(var i=0; i < daftarToko.length; i++){
    list.add(new CustomCard(daftarToko[i].namaToko, daftarToko[i].namaPerusahaan, i+1));
  }
  return list;
}

List<Text> getTokoWidgetText(List<Toko> daftarToko, String str){
  List<Text> list = [];
  for(var i=0; i < daftarToko.length; i++){
    list.add(new Text(daftarToko[i].namaToko+'\n'));
  }
  return list;
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarToko(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        scaffoldBackgroundColor: const Color.fromRGBO(242, 255, 253, 1),
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(48, 158, 158, 1.0),
            ),
            headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}

class DaftarToko extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(), 
        backgroundColor: const Color.fromRGBO(201, 244, 255, 1),
        // https://www.kindacode.com/article/flutter-add-a-search-field-to-the-app-bar/
        appBar: AppBar(
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
            // https://www.kindacode.com/article/flutter-add-a-search-field-to-the-app-bar/
              child: MyCustomForm(),
            ), 
          )
          ),
         body: new Container(
              child: new ListView(
                children: getTokoWidget(DAFTAR_TOKO),
              )

            ),
      
    );
  }
}

// Diolah dari https://docs.flutter.dev/cookbook/forms/retrieve-input
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                controller: myController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      tooltip: 'Cari toko!',
                      icon: Icon(Icons.search),
                      onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Hasil pencarian untuk '+myController.text+':\n(Fungsi pencarian masih belum benar, hanya untuk testing form saja)',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                ),
                                // Retrieve the text the user has entered by using the
                                // TextEditingController.
                                content: setAlertDialogColumn(),
                              ); 
                            },
                          );
                        },
                      ),
                    prefixIcon: IconButton(
                      tooltip: 'Hapus pencarian!',
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                        myController.text = '';
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              );
  }

  Widget setAlertDialogColumn() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0,
      child: ListView(
        children: getTokoWidgetText(DAFTAR_TOKO, myController.text),
    ),
    );
  }
}



// processed from https://stackoverflow.com/questions/49819221/flutter-cards-how-to-loop-a-card-widgets-in-flutter
class CustomCard extends StatelessWidget {
  String nama_toko="";
  String nama_perusahaan="";
  String photo_id="";
  CustomCard(String nama_toko, String nama_perusahaan, int photo_id){
    this.nama_toko = nama_toko;
    this.nama_perusahaan = nama_perusahaan;
    this.photo_id = photo_id.toString();
  }
  @override
  Widget build(BuildContext context) {
              return new Card(
                      child: InkWell(                        
                        child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Column(
                            children: <Widget>[
                              new Image.asset('/images/'+this.photo_id+'.jpg',width:300,height:300),
                              new Padding(
                               padding: new EdgeInsets.all(7.0),
                               child: new Text(this.nama_toko ,style: new TextStyle(fontSize: 18.0),
                              ),
                              ),
                              new Padding(
                               padding: new EdgeInsets.all(7.0),
                               child: new Text(this.nama_perusahaan ,style: new TextStyle(fontSize: 13.0),
                               ),
                             ),
                            ],
                          )
                        )
                      ],
                    ),                      
                        onTap: () {                          
                        print("tapped on card");
                        },                      
                      )
                      
                  );
  }
}