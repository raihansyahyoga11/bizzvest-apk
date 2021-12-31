// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  static const String protocol = (kReleaseMode)? "https://" : "http://";
  static const String host =
        (kReleaseMode)? "bizzvest-bizzvest.herokuapp.com" :
            (kIsWeb? "127.0.0.1:8000" : "10.0.2.2:8000");

  static const String login_path = "/start-web/login-flutter";
  static const String acc_info = "/halaman-toko/account-information";

  static const String halaman_toko_get_photo_json_path = "/halaman-toko/halaman-toko-photo-json";
  static const String halaman_toko_get_toko_json_path = "/halaman-toko/halaman-toko-json";
  static const String halaman_toko_save_company_form = "/halaman-toko/save-edited-company-form";
  static const String halaman_toko_upload_proposal = "/halaman-toko/upload-proposal";
  static const String halaman_toko_ajukan_verifikasi = "/halaman-toko/request-for-verification";
  static const String halaman_toko_add_toko_API = "/halaman-toko/add-toko-api";
  static const String halaman_toko_manage_photos_init_api = "/halaman-toko/manage-photos-init-api";
  static const String halaman_toko_add_photo = "/halaman-toko/add-photo";
  static const String halaman_toko_set_photos_order = "/halaman-toko/photo-reorder";
  static const String halaman_toko_delete_photo = "/halaman-toko/delete-photo";

  static final Uri server_uri = Uri.http(host, '/');
  static final Uri login_uri = Uri.http(host, login_path);

  static Uri get_server_URI(String path, [Map<String, dynamic> query=const {}]){
    return Uri.http(host, path, query);
  }

  static String get_server_URL(String path, [Map<String, dynamic>? query]){
    return Uri.http(host, path, query).toString();
  }
}

class COOKIE_CONST{
  static const String csrf_token_formdata = "csrfmiddlewaretoken";
  static const String csrf_token_cookie_name = "csrftoken";
  static const String session_id_cookie_name = "sessionid";
}

class STYLE_CONST{
  static final Color? background_color = Colors.lightBlue[200];

  static ThemeData default_theme_of_halamanToko(BuildContext context){
    return ThemeData(
      textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.3,
          fontSizeDelta: 2.0,
          fontFamily: 'Tisan'
      ),
    );
  }
}


class ReqResponse<T>{
  late bool is_dio;
  late dio.Response<T> dio_resp;
  late http.Response http_resp;

  bool get has_problem{
    return statusCode == null || statusCode! < 200 || statusCode! >= 400;
  }

  int? get statusCode{
    if (is_dio)
      return dio_resp.statusCode;
    return http_resp.statusCode;
  }

  dynamic get body{
    return data;
  }

  dynamic get data{
    if (is_dio)
      return dio_resp.data;
    return http_resp.body;
  }

  String? get data_string{
    if (is_dio)
      return cast<String>(dio_resp.data);
    return http_resp.body;
  }

  String? get statusMessage{
    return reasonPhrase;
  }

  String? get reasonPhrase{
    if (is_dio)
      return dio_resp.statusMessage;
    return http_resp.reasonPhrase;
  }

  ReqResponse({dio.Response<T>? dio, http.Response? http}){
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

  static T? cast<T>(dynamic obj) => (obj is T)? obj:null;

  @override
  String toString() {
    if (is_dio)
      return dio_resp.toString();
    return http_resp.toString();
  }
}

class TimeoutResponse<T> extends ReqResponse<T>{
  TimeoutResponse() : super(http: http.Response("", 408));
}


class Authentication extends Session{
  bool _is_logged_in = false;
  bool get is_logged_in{
    return _is_logged_in;
  }

  Authentication({required cookie_jar}) : super(cookie_jar: cookie_jar);

  @deprecated
  Future<String?> get_csrf_token({Uri? uri=null}) async{
    uri ??= NETW_CONST.login_uri;
    Cookie? result = await get_cookie(name: COOKIE_CONST.csrf_token_cookie_name, uri: uri);
    return result?.value;
  } 
  
  Future<Cookie?> get_cookie({Uri? uri=null, required String name}) async {
    uri ??= NETW_CONST.get_server_URI("/");
    List<Cookie> cookies = await cookie_jar.loadForRequest(uri);
    for (var i=0; i < cookies.length; i++){
      if (cookies[i].name == name)
        return cookies[i];
    }
  }

  static Future<Authentication> create() async {
    assert (kIsWeb == false, "Authentication() tidak bisa digunakan di website");

    Authentication comp;
    Directory temp = await getApplicationDocumentsDirectory();
    Directory dir =
        await (Directory(temp.path + '/' + '.cache').create(recursive: true));

    comp = Authentication(
        cookie_jar:
            PersistCookieJar(storage: FileStorage(dir.path + "/.cache")));
    return comp;
  }

  Future<ReqResponse> login(String username, String password) async {
    var form = <String, String>{
      'username': username,
      'password': password,
    };

    ReqResponse ret = await post(uri: NETW_CONST.login_uri, data: form);
    print(await cookie_jar);
    if (!ret.has_problem){
      await refresh_is_logged_in();
    }else if (kDebugMode){
      print("login problem 1: ${ret.statusCode} ${ret.reasonPhrase}}");
      print("");
      print(ret.data);
    }
    return ret;
  }

  Future<ReqResponse> refresh_is_logged_in() async {
    ReqResponse resp = await get(
        uri: NETW_CONST.get_server_URI(NETW_CONST.acc_info));

    if (!resp.has_problem && json.decode(resp.body)['is_logged_in'] == 1){
      _is_logged_in = true;
    }
    return resp;
  }

  Future<ReqResponse> set_session_id(String session_id, [Uri? uri]) async {
    uri ??= NETW_CONST.server_uri;
    cookie_jar.delete(uri);
    cookie_jar.saveFromResponse(uri, [Cookie(
        COOKIE_CONST.session_id_cookie_name,
        session_id
    )]);

    return await refresh_is_logged_in();
  }
}



class Session{
  static const bool DEBUG = kDebugMode;
  static const _default_timeout = 10000;

  var dio =  Dio(BaseOptions(
      connectTimeout: _default_timeout,
      receiveTimeout: _default_timeout,
      sendTimeout: _default_timeout,
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


  Future<ReqResponse<dynamic>> get({
          Uri? uri, String? url, Map<String, String>? data
        }) async{
    assert (uri == null && url != null || url == null && uri != null);

    if (uri != null){
      if (data != null){
        Uri new_uri = Uri(
          scheme: uri.scheme,
          userInfo: uri.userInfo,
          host: uri.host,
          port: uri.port,
          pathSegments: uri.pathSegments,
          query: uri.query,
          queryParameters: {...uri.queryParameters, ...data},
          fragment: uri.fragment,
        );
        return ReqResponse<dynamic>(dio: await dio.getUri(new_uri));
      }else return ReqResponse<dynamic>(dio: await dio.getUri(uri));
    }else{
      assert (url != null);
      return ReqResponse<dynamic>(dio: await dio.get(url!, queryParameters:data));
    }
  }

  Future<ReqResponse<dynamic>> post({
          Uri? uri, String? url,
          Duration timeout = const Duration(seconds: 5),
          Map<String, dynamic>? data,
          FormData? form_data,
        }) async{
    assert (uri == null && url != null || url == null && uri != null);
    assert (data == null && form_data != null || form_data == null && data != null);

    if (uri != null){
      return ReqResponse<dynamic>(
          dio: await dio.postUri(
            uri,
            data: (data!=null)? FormData.fromMap(data):form_data!,
        ));
    }else{
      assert (url != null);
      return ReqResponse<dynamic>(dio: await dio.post(
          url!,
          data: (data!=null)? FormData.fromMap(data):form_data!
      ));
    }
  }

}



@deprecated  // ga working
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

@deprecated
class SessionOld{
  // static const bool DEBUG = kDebugMode;
  static const bool DEBUG = false;

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


