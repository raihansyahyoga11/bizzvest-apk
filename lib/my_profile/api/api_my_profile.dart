import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/UserAccount.dart';
import '../screens/ProfilePage.dart';
import '../screens/EditingPage.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';

  Future<String> _loadAUserAsset() async {
    // var auth = await get_authentication(context);
    final response = await http.get(Uri.parse('https://bizzvest-bizzvest.herokuapp.com/my-profile/my-profile-json'),
    );
    return response.body;
  }

  Future<User> loadUser() async {
  await wait(1);
  String jsonString = await _loadAUserAsset();
  final jsonResponse = json.decode(jsonString);
  return new User.fromJson(jsonResponse);
  }


  Future wait(int seconds) {
    return new Future.delayed(Duration(seconds: seconds), () => {});
  }

  // Future<User> kirimDataUser() async {
  //     final response = await http.post(Uri.parse("http://10.0.2.2:8000/my-profile/my-profile-json"),
  //     headers: {"Content-Type":"application/json"},
  //     body:json.encode(<String, dynamic>{
  //       'username': "",
  //       'nama_lengkap':

  //     }));
  // }

  
  // void getReq() async {
  //     final response = await http.get(Uri.parse("http://10.0.2.2:8000/my-profile/my-profile-json"));
  //     Map<String,dynamic> userMap =jsonDecode(response.body);
  //     // var user = User.fromJson(userMap);
  //     print(userMap);
  //   }
