import 'package:bizzvest/daftar_toko/api/api_daftar_toko.dart';
import 'package:bizzvest/daftar_toko/utility/list_daftar_toko.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bizzvest/daftar_toko/screen/daftar_toko.dart';

// Diolah dari https://docs.flutter.dev/cookbook/forms/retrieve-input
class SearchForm extends StatefulWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SearchFormState extends State<SearchForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final search_text = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    search_text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: search_text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
          suffixIcon: IconButton(
            tooltip: 'Cari toko!',
            icon: Icon(Icons.search),
            onPressed: () async {
              final response = await http.post(Uri.parse('http://10.0.2.2:8000/daftar-toko/search/'),
                  headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8'
                  },
                  body: jsonEncode(<String, String>{
                    'search_text' : search_text.text,
                  }
                )
              );

              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DaftarTokoMaterial()));

            }
            // {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           title: Text(
            //             'Hasil pencarian untuk '+search_text.text+':\n(Fungsi pencarian masih belum benar, hanya untuk testing form saja)',
            //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
            //           ),
            //           // Retrieve the text the user has entered by using the
            //           // TextEditingController.
            //           content: setAlertDialogColumn(),
            //         ); 
            //       },
            //     );
            //   },
            ),
            prefixIcon: IconButton(
            tooltip: 'Hapus pencarian!',
            icon: Icon(Icons.clear),
            onPressed: () {
              /* Clear the search field */
              search_text.text = '';
            },
          ),
          hintText: 'Search...',
          border: InputBorder.none
          ),
        );
  }

  Widget setAlertDialogColumn() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0,
      child: ListView(
        // children: getTokoWidgetText(DAFTAR_TOKO, search_text.text),
    ),
    );
  }
}