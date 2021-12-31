import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bizzvest/daftar_toko/screen/daftar_toko.dart';
import 'package:bizzvest/daftar_toko/api/api_daftar_toko.dart';
import 'package:bizzvest/daftar_toko/utility/list_daftar_toko.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';

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
  final onSearchText = TextEditingController();
  String searchText = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    onSearchText.dispose();
    super.dispose();
  }

  void onPressedSearch() {
    searchText = onSearchText.text;
    Navigator.push(context, MaterialPageRoute(builder: (context) => DaftarTokoMaterial(searchText: searchText,)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: TextFormField(
      controller: onSearchText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          tooltip: 'Cari toko!',
          icon: Icon(Icons.search),
          onPressed: onPressedSearch
          ),
          prefixIcon: IconButton(
          tooltip: 'Hapus pencarian!',
          icon: Icon(Icons.clear),
          onPressed: () {
            /* Clear the search field */
            searchText = '';
            onSearchText.text = '';
          },
        ),
        hintText: 'Search...',
        border: InputBorder.none
        ),
      )
    );
  }
}