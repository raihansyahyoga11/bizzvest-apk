import 'dart:convert';
import 'package:http/http.dart' as http;
import 'daftar_toko/models/toko.dart';


Future<List<Toko>?> fetchDaftarToko() async {
  final response = await http.get(Uri.parse('https://bizzvest.herokuapp.com/daftar-toko/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, parse the JSON.
    return parseItem(response.body);
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load GET');
  }
}

List<Toko>? parseItem(String responseBody) {
  final List<Toko> questions = [];
  final parsed = jsonDecode(responseBody) as List<dynamic>;
  for (var e in parsed) {
    questions.add(Toko.fromJson(e));
  }

  return questions;
}
