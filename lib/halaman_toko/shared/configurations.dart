// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';



void main() async {
  print("running");
  Authentication auth = Authentication(cookie_jar: CookieJar());

  var res = await auth.post(
    // url: "https://reqres.in/api/users/5",
    uri: Uri.parse("https://httpbin.org/post"),
    data: {
      "c": "d",
      "e": "f",
    },
  );
  print(res);

  print("finished");


  AuthenticationOld authold = AuthenticationOld();
  var res2 = await authold.post(
    uri: Uri.parse("https://httpbin.org/post"),
    data: {"a": "b"},
  );

  print(res2.body);

  print("res2 finished");
}



class NETW_CONST{
  // static final String server = "bizzvest.herokuapp.com";
  static const String server = (kReleaseMode)? "bizzvest.herokuapp.com" : "10.0.2.2:8000";
  // static final String server = (kReleaseMode)? "bizzvest.herokuapp.com" : "192.168.43.117:8000";
  static const String protocol = "http://";

  static const String login_path = "/start-web/login";

  static const String halaman_toko_get_photo_json_path = "/halaman-toko/halaman-toko-photo-json";
  static const String halaman_toko_get_toko_json_path = "/halaman-toko/halaman-toko-json";
  static const String halaman_toko_save_company_form = "/halaman-toko/save-edited-company-form";

  static final Uri server_uri = Uri.http(server, '/');
  static final Uri login_uri = Uri.http(server, login_path);

  static get_server_URI(String path, [Map<String, dynamic> query=const {}]){
    return Uri.http(server, path, query);
  }
}

class COOKIE_CONST{
  static const String csrf_token_formdata = "csrfmiddlewaretoken";
  static const String csrf_token_cookie_name = "csrftoken";
}


class Response<T>{
  late bool is_dio;
  late dio.Response dio_resp;
  late http.Response http_resp;

  bool get has_problem{
    return statusCode < 200 || statusCode >= 400;
  }

  get statusCode{
    if (is_dio)
      return dio_resp.statusCode;
    return http_resp.statusCode;
  }

  get body{
    return data;
  }

  get data{
    if (is_dio)
      return dio_resp.data;
    return http_resp.body;
  }

  get statusMessage{
    return reasonPhrase;
  }

  get reasonPhrase{
    if (is_dio)
      return dio_resp.statusMessage;
    return http_resp.reasonPhrase;
  }

  Response({dio.Response<T>? dio, http.Response? http}){
    assert ((dio == null && http != null) || (dio != null && http == null));

    if (dio != null){
      dio_resp = dio;
      is_dio = true;
    }
    if (http != null){
      http_resp = http;
      is_dio = false;
    }

  }


  @override
  String toString() {
    return data.toString();
  }

}


class Authentication extends Session{
  bool is_logged_in = false;

  Authentication({required cookie_jar}) : super(cookie_jar: cookie_jar);

  @deprecated
  Future<String?> get_csrf_token({Uri? uri=null}) async{
    uri ??= NETW_CONST.login_uri;
    Cookie? result = await get_cookie(name: COOKIE_CONST.csrf_token_cookie_name, uri: uri);
    return result?.value;
  } 
  
  Future<Cookie?> get_cookie({Uri? uri=null, required String name}) async {
    uri ??= NETW_CONST.get_server_URI("/");
    List<Cookie> cookies = await cookie_jar.loadForRequest(uri!);
    for (var i=0; i < cookies.length; i++){
      if (cookies[i].name == name)
        return cookies[i];
    }
  }

  static Future<Authentication> create() async {
    Directory temp = await getApplicationDocumentsDirectory();
    Directory dir = await (Directory(temp.path + '/' + '.cache').create(recursive: true));

    var comp = Authentication(cookie_jar: PersistCookieJar(
        storage: FileStorage(dir.path + "/.cache")
    ));
    return comp;
  }

  Future<Response> login(String username, String password) async {
    var form = <String, String>{
      'username': username,
      'password': password,
    };

    Response ret = await post(uri: NETW_CONST.login_uri, data: form);

    if (ret.statusCode >= 200 && ret.statusCode < 400){
      is_logged_in = true;
      if (kDebugMode) {
        print("logged in " + ret.statusCode.toString() + " " + (ret.reasonPhrase ?? "null"));
      }
    }
    return ret;
  }
}

class Session{
  static const bool DEBUG = kDebugMode;
  static const default_timeout = 10000;

  var dio =  Dio(BaseOptions(
      connectTimeout: default_timeout,
      receiveTimeout: default_timeout,
      sendTimeout: default_timeout,
      responseType: ResponseType.plain,
      followRedirects: false,
      validateStatus: (status) { return true; }
  ));
  late CookieJar cookie_jar;

  Session({required cookie_jar}){
    this.cookie_jar=cookie_jar;
    dio.interceptors.add(CookieManager(cookie_jar));
  }

  static Future<Session> create() async {
    Directory temp = await getApplicationDocumentsDirectory();
    Directory dir = await (Directory(temp.path + '/' + '.cache').create(recursive: true));

    var comp = Session(cookie_jar: PersistCookieJar(
      storage: FileStorage(dir.path + "/.cache")
    ));
    return comp;
  }

  static is_timeout_error(Object? error){
    if (error is TimeoutException)
      return true;

    DioError? dio_error = null;
    if (error is DioError)
      dio_error = error as DioError;

    if (dio_error?.type == DioErrorType.connectTimeout)
      return true;
    if (dio_error?.type == DioErrorType.receiveTimeout)
      return true;
    if (dio_error?.type == DioErrorType.sendTimeout)
      return true;
    return false;
  }

  Map<String, String> header = {};
  Future<Response<dynamic>> get({
          Uri? uri, String? url, Map<String, dynamic>? data
        }) async{
    assert (uri == null && url != null || url == null && uri != null);

    if (uri != null){
      return Response<dynamic>(dio: await dio.getUri(uri));
    }else{
      assert (url != null);
      return Response<dynamic>(dio: await dio.get(url!, queryParameters:data));
    }
  }

  Future<Response<dynamic>> post({
          Uri? uri, String? url, Duration timeout = const Duration(seconds: 5), required Map<String, dynamic> data
        }) async{
    assert (uri == null && url != null || url == null && uri != null);

    if (uri != null){
      return Response<dynamic>(
          dio: await dio.postUri(
            uri,
            data: FormData.fromMap(data),
        ));
    }else{
      assert (url != null);
      return Response<dynamic>(dio: await dio.post(
          url!,
          data: FormData.fromMap(data)
      ));
    }
  }

}




class AuthenticationOld extends SessionOld{
  bool is_logged_in = false;

  Future<http.Response> login(String username, String password) async {
    var form = <String, String>{
      'username': username,
      'password': password,
    };

    var ret = await post(uri: NETW_CONST.login_uri, data: form);

    if (ret.statusCode >= 200 && ret.statusCode < 400){
      is_logged_in = true;
      if (kDebugMode) {
        print("logged in " + ret.statusCode.toString() + " " + (ret.reasonPhrase ?? "null"));
      }
    }
    return ret;
  }

}

class SessionOld{
  static const bool DEBUG = kDebugMode;

  Map<String, String> header = {};
  Future<http.Response> get({
          Uri? uri,
          String? url,
          Duration timeout = const Duration(seconds: 9),
        }) async{
    assert (uri == null && url != null || url == null && uri != null);


    uri ??= Uri.parse(url!);

    if (DEBUG)
      print(header['cookie']);

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

    if (DEBUG)
      print(header['cookie']);

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
       print("headers");
       print(response.headers.entries);
       print("cookies");
       print(cookie_string);


       header['cookie'] = cookie_string;
int index_end = cookie_string.indexOf(';');
       index_end = (index_end == -1)? cookie_string.length:index_end;
       header['cookie'] = cookie_string.substring(0, index_end);

     }
  }

}


