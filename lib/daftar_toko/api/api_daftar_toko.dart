import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bizzvest/daftar_toko/models/toko.dart';

Future<List<Toko>?> fetchDaftarToko() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/daftar-toko/search/'));
  if (response.statusCode == 200) {
  // If the server did return a 200 OK response,
  // then parse the JSON.
    return parseDaftarToko(response.body);
  } else {
    // If the server did not return a 200 OK response,d
    // then throw an exception.
    throw Exception('Failed to load Get');
  }
}

List<Toko>? parseDaftarToko(String response){
  final List<Toko> listDaftarToko = [];
  final parsedData = jsonDecode(response) as List<dynamic>;
  for (var e in parsedData) {
    listDaftarToko.add(Toko?.fromJson(e));
  }
  return listDaftarToko;
}

// Future<Toko> loadToko() async {
// await wait(1);
// String jsonString = await loadTokoAsset();
// final jsonResponse = json.decode(jsonString);
// return Toko.fromJson(jsonResponse);
// }

// Future wait(int seconds) {
//   return Future.delayed(Duration(seconds: seconds), () => {});
// }

