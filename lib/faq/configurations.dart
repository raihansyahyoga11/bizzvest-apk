

import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class CONSTANTS{
  static final String server = "10.0.2.2:8000";
  static final String login_path = "/start-web/login";
  static final String halaman_toko_get_json_path = "/halaman-toko/photo_json";

  static final Uri server_uri = Uri.http(server, '/');
  static final Uri login_uri = Uri.http(server, login_path);

  static getServerUri(String path, Map<String, dynamic> query){
    return Uri.http(server, path, query);
  }
}


class Authentication{
  Session session = Session();

  Future<http.Response> login(String username, String password) async {
    var form = <String, String>{
      'username': username,
      'password': password,
    };

    return await session.post(uri: CONSTANTS.login_uri, data: form);
  }
}



class Session{
  Map<String, String> header = {};
  Future<http.Response> get({
          Uri? uri,
          String? url,
        }) async{
    assert (uri == null && url != null || url == null && uri != null);

    uri ??= Uri.parse(url!);

    http.Response response = await http.get(
        uri,
        headers: header,
    );
    set_cookie(response);
    return response;
  }


  Future<http.Response> post({
          Uri? uri,
          String? url,
          required dynamic data
        }) async{
    assert (uri == null && url != null || url == null && uri != null);

    uri ??= Uri.parse(url!);
    http.Response response = await http.post(
        uri,
        body: data,
        headers: header,
    );
    set_cookie(response);
    return response;
  }


  void set_cookie(http.Response response){
     String? cookie_string = response.headers['set-cookie'];

     if (cookie_string != null){
       int index_end = cookie_string.indexOf(';');
       index_end = (index_end == -1)? cookie_string.length:index_end;
       header['cookie'] = cookie_string.substring(0, index_end);
     }
  }

}