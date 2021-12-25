// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko_body.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bizzvest/halaman_toko/shared/user_account.dart';
import 'package:http/http.dart';

import 'halaman_toko_properties.dart';

void main() async {
  await initialize();
  runApp(const HalamanToko(id:8));
}


Future<void> initialize() async {
}


class HalamanToko extends StatefulWidget{
  final int id;
  const HalamanToko({this.id=1, Key? key}) : super(key: key);

  @override
  State<HalamanToko> createState() => _HalamanTokoState();
}

class _HalamanTokoState extends State<HalamanToko> {
  static const int TIMEOUT_RETRY_LIMIT = 5;
  int timeout_retry_number = 0;

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: () async {
        var authentication = await get_authentication();
        Response? ret = await authentication.get(
            uri: CONSTANTS.get_server_URI(
                CONSTANTS.halaman_toko_get_toko_json_path,
                {'id': widget.id.toString()}
            ));
        return ret;
      }(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError) {
            if (snapshot.error is TimeoutException){
              if (timeout_retry_number < TIMEOUT_RETRY_LIMIT) {
                Future.delayed(Duration(seconds: 2+timeout_retry_number))
                    .then((value) => setState(() {timeout_retry_number += 1;}));
              }

              return Container(
                child: const Center(
                  child: Text(
                    "Request timed out",
                    textDirection: TextDirection.ltr,
                  ),
                ),
              );
            }

            Future.error(
              snapshot.error!,
              snapshot.stackTrace);
          }

          if (snapshot.hasError
              || snapshot.data == null
              || is_bad_response(snapshot.data!)){

            return Container(
              child: const Center(
                child: Text(
                    "An error has occurred. ",
                    textDirection: TextDirection.ltr,
                ),
              ),
            );
          }else{
            Response response = snapshot.data!;
            Map<String, dynamic> resulting_json = json.decode(response.body);
            List<dynamic> images_str = resulting_json['images'];
            List<Image> images = [];

            images_str.forEach((dynamic element_dynamic) {
              String element = element_dynamic;
              images.add(Image.network(
                  CONSTANTS.protocol + CONSTANTS.server + element));
            });

            assert (resulting_json['is_curr_client_the_owner'] is int);

            return HalamanTokoWrapper(
                child: HalamanTokoBody(
                    HalamanTokoProperties(
                      id: widget.id,
                      show_edit_option: resulting_json['is_curr_client_the_owner'] == 1,
                      nama_merek: resulting_json['nama_merek'],
                      nama_perusahaan: resulting_json['nama_perusahaan'],
                      images: images,
                      status_verifikasi: resulting_json['status_verifikasi'],
                      tanggal_berakhir: resulting_json['tanggal_berakhir'],

                      kode_saham: resulting_json['kode_saham'],
                      sisa_waktu: resulting_json['sisa_waktu'],
                      periode_dividen: resulting_json['periode_dividen'].toString() + " bulan",
                      alamat: resulting_json['alamat'],
                      deskripsi: resulting_json['deskripsi'],
                      alamat_proposal: resulting_json['alamat_proposal'],
                      owner: UserAccount(
                        full_name: resulting_json['owner']['full_name'],
                        username: resulting_json['owner']['username'],
                        photo_profile: Image.network(
                            CONSTANTS.protocol + CONSTANTS.server
                                + resulting_json['owner']['photo_profile']
                        ),
                      ),

                      nilai_lembar_saham: resulting_json['nilai_lembar_saham'],
                      jumlah_lembar_saham: resulting_json['jumlah_lembar_saham'],
                      jumlah_lembar_saham_tersisa: resulting_json['jumlah_lembar_saham_tersisa'],
                    )
                )
            );
          }
        }else{
          return Container(
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Center(
                        child: CircularProgressIndicator()
                    ),
                    SizedBox(width:0, height:20),
                    Center(
                        child: Text(
                          "Fetching company information",
                          textDirection: TextDirection.ltr,)
                    ),
                  ]
              ),
            ),
          );
        }
      },
    );
  }
}


class HalamanTokoWrapper extends StatelessWidget{
  final Widget child;
  const HalamanTokoWrapper({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget temp_child = child;

    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.3,
          fontSizeDelta: 2.0,
          fontFamily: 'Tisan'
        ),
      ),

      home: SafeArea(child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10),
          child: temp_child,
        ),
        backgroundColor: (Colors.lightBlue[200])!,

        floatingActionButton: null,
      ),
      ),
    );
  }
}


class HalamanTokoInheritedWidget extends InheritedWidget{
  final HalamanTokoProperties properties;
  final Function(Function() func)? setState;

  const HalamanTokoInheritedWidget({
    required this.properties,
    required Widget child,
    required this.setState,
    Key? key,
  }) : super(key: key, child: child);

  static HalamanTokoInheritedWidget of(BuildContext context){
    final HalamanTokoInheritedWidget? ret
      = context.dependOnInheritedWidgetOfExactType<HalamanTokoInheritedWidget>();
    assert (ret != null, 'HalamanTokoInheritedWidget is not found in the context');
    return ret!;
  }

  @override
  bool updateShouldNotify(covariant HalamanTokoInheritedWidget old) {
    return properties != old.properties;
  }
}


