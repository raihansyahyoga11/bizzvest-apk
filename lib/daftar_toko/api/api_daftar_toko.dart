import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bizzvest/daftar_toko/models/toko.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';

Future<List<Toko>?> fetchDaftarToko(String searchText) async {

  final response = await http.post(NETW_CONST.get_server_URI('/daftar-toko/json/'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'search_text' : searchText,
      }
    )
  );
           
  //final response = await http.get(Uri.parse(NETW_CONST.protocol + NETW_CONST.host+'/daftar-toko/search/'), headers: {"Accept": "application/json"});
  if (response.statusCode == 200) {
    print("code 200 success");
  // If the server did return a 200 OK response,
  // then parse the JSON.
    return parseDaftarToko(response.body);
  } else {
    // If the server did not return a 200 OK response,d
    // then throw an exception.
    print("$response.statusCode "+response.body);
    throw Exception('Failed to load Get');
  }
}

List<Toko>? parseDaftarToko(String response){
  final List<Toko> listDaftarToko = [];
  Map<String, dynamic> map = json.decode(response);
  final List<dynamic> parsedData = map["company_search"];
  // final parsedData = jsonDecode(response) as List<dynamic>;
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

