import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;


void main() async {
  var auth_1 = Authentication(cookie_jar: CookieJar());
  var auth_2 = Authentication(cookie_jar: CookieJar());
  var auth_3 = Authentication(cookie_jar: CookieJar());

  ReqResponse r1 = await auth_1.login("my account", "yow");
  ReqResponse r2 = await auth_2.login("hzz", "1122");
  ReqResponse r3 = await auth_3.login("hzz", "1123");
  print("${auth_1.is_logged_in}");
  print("${auth_2.is_logged_in}");
  print("${auth_3.is_logged_in}");
}