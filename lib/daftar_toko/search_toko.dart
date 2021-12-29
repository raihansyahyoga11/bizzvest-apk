import 'package:flutter/material.dart';

import './daftar_toko.dart';

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