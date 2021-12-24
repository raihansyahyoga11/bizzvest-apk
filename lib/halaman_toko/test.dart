import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;


void main() async {
  var dio =  Dio(BaseOptions(
      connectTimeout: 10000,  // in ms
      receiveTimeout: 10000,
      sendTimeout: 10000,
      responseType: ResponseType.plain,
      followRedirects: false,
      validateStatus: (status) { return true; }
  ));   // some dio configurations

  dio.interceptors.add(CookieManager(CookieJar()));


  var firstResponse = await dio.post(
      "http://10.0.2.2:8000/halaman-toko/origin-information");
  print(firstResponse.data);


  var resp_http = await http.get(Uri.parse("http://10.0.2.2:8000/halaman-toko/origin-information"));
  var resp2_http = await http.post(Uri.parse("http://10.0.2.2:8000/halaman-toko/origin-information"));

  print(resp_http.body);
  print(resp2_http.body);
}