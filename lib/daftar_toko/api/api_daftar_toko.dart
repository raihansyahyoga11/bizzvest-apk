import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Toko.dart';

  Future<String> _loadTokoAsset() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/my-profile/my-profile-json'), headers: {"Accept": "application/json"});
    return response.body;
  }

  Future<Toko> loadToko() async {
  await wait(1);
  String jsonString = await _loadTokoAsset();
  final jsonResponse = json.decode(jsonString);
  return Toko.fromJson(jsonResponse);
  }


  Future wait(int seconds) {
    return Future.delayed(Duration(seconds: seconds), () => {});
  }

