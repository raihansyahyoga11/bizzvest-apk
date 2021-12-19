import 'dart:async';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;


class CONSTANTS{
  static final String server = "10.0.2.2:8000";
  static final String protocol = "http://";

  static final String login_path = "/start-web/login";
  static final String halaman_toko_get_photo_json_path = "/halaman-toko/halaman-toko-photo-json";
  static final String halaman_toko_get_toko_json_path = "/halaman-toko/halaman-toko-json";

  static final Uri server_uri = Uri.http(server, '/');
  static final Uri login_uri = Uri.http(server, login_path);

  static get_server_URI(String path, Map<String, dynamic> query){
    return Uri.http(server, path, query);
  }
}


class Authentication extends Session{
  bool is_logged_in = false;

  Future<http.Response> login(String username, String password) async {
    var form = <String, String>{
      'username': username,
      'password': password,
    };

    var ret = await post(uri: CONSTANTS.login_uri, data: form);

    if (ret.statusCode >= 200 && ret.statusCode < 400){
      is_logged_in = true;
    }
    return ret;
  }

}



class Session{
  Map<String, String> header = {};
  Future<http.Response> get({
          Uri? uri,
          String? url,
          Duration timeout = const Duration(seconds: 5),
        }) async{
    assert (uri == null && url != null || url == null && uri != null);


    uri ??= Uri.parse(url!);


    var request_future = http.get(
      uri,
      headers: header,
    );

    var faster_future = await Future.any([
      Future.delayed(timeout),
      request_future
    ]);

    if (faster_future is! http.Response)
      throw TimeoutException("get request timed out");

    http.Response response = faster_future;
    set_cookie(response);
    return response;
  }


  Future<http.Response> post({
          Uri? uri,
          String? url,
          Duration timeout = const Duration(seconds: 5),
          required dynamic data
        }) async{
    assert (uri == null && url != null || url == null && uri != null);

    uri ??= Uri.parse(url!);

    var request_future = http.post(
      uri,
      body: data,
      headers: header,
    );

    var faster_future = await Future.any([
      Future.delayed(timeout),
      request_future
    ]);

    if (faster_future is! http.Response)
      throw TimeoutException("post request timed out");

    http.Response response = faster_future;
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