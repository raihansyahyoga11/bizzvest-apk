// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko_body.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/loading_screen.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bizzvest/halaman_toko/shared/user_account.dart';

import 'halaman_toko_properties.dart';

void main() async {
  await initialize();
  runApp(HalamanTokoMaterialApp(id:13));
}


Future<void> initialize() async {
}


class HalamanTokoMaterialApp extends StatelessWidget{
  final int id;
  const HalamanTokoMaterialApp({this.id=1, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
            fontSizeFactor: 1.3,
            fontSizeDelta: 2.0,
            fontFamily: 'Tisan'
        ),
      ),

      home: HalamanToko(id: id),
    );
  }
}


class HalamanToko extends StatefulWidget{
  final int id;
  final GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();
  HalamanToko({this.id=1, Key? key}) : super(key: key);

  @override
  State<HalamanToko> createState() => _HalamanTokoState();
}

class _HalamanTokoState extends State<HalamanToko> {
  GlobalKey<ScaffoldState> get scaffold_key{
    return widget.scaffold_key;
  }

  @override
  Widget build(BuildContext context){
    Function(Function()) refresh_page = setState;

    return RequestLoadingScreenBuilder(
      request_function: () async {
        var authentication = await get_authentication();
        ReqResponse? ret = await authentication.get(
            uri: NETW_CONST.get_server_URI(
                NETW_CONST.halaman_toko_get_toko_json_path,
                {'id': widget.id.toString()}
            ));
        return ret;
      },

      wrapper: (widget, status) {
        if (status != RequestStatus.success) {
          return Scaffold(
            key: scaffold_key,
            body: widget,
            backgroundColor: STYLE_CONST.background_color,
          );
        }

        return HalamanTokoWrapper(
          child: widget,
          scaffold_key: scaffold_key,
        );
      },

      on_success: (context, snapshot, response, refresh) {
        ReqResponse response = snapshot.data!;
        Map<String, dynamic> resulting_json = json.decode(response.body);
        List<dynamic> images_str = resulting_json['images'];
        List<Image> images = [];

        images_str.forEach((dynamic element_dynamic) {
          String element = element_dynamic;
          images.add(Image.network(
              NETW_CONST.protocol + NETW_CONST.host + element));
        });

        assert (resulting_json['is_curr_client_the_owner'] is int);
        print("curr owner ${resulting_json['is_curr_client_the_owner'] }");
        print("your acc ${resulting_json['your_acc'] }");

        return HalamanTokoBody(
            refresh_page: refresh_page,
            scaffold_key: scaffold_key,
            csrf_token: resulting_json['csrf_token'],
            properties: HalamanTokoProperties(
              id: widget.id,
              is_curr_client_the_owner: resulting_json['is_curr_client_the_owner'] == 1,
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
              proposal_server_path: resulting_json['alamat_proposal'],
              owner: UserAccount(
                full_name: resulting_json['owner']['full_name'],
                username: resulting_json['owner']['username'],
                photo_profile: Image.network(
                    NETW_CONST.protocol + NETW_CONST.host
                        + resulting_json['owner']['photo_profile']
                ),
              ),

              nilai_lembar_saham: resulting_json['nilai_lembar_saham'],
              jumlah_lembar_saham: resulting_json['jumlah_lembar_saham'],
              jumlah_lembar_saham_tersisa: resulting_json['jumlah_lembar_saham_tersisa'],
            )
        );
      },
      /*builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError) {
            if (Session.is_timeout_error(snapshot.error)){

              if (timeout_retry_number < TIMEOUT_RETRY_LIMIT) {
                Future.delayed(Duration(seconds: 2+timeout_retry_number))
                    .then((value) => setState(() {timeout_retry_number += 1;}));
              }

              return Scaffold(
                body: Container(
                  child: const Center(
                    child: Text(
                      "Request timed out",
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              );
            }

            Future.error(
              snapshot.error!,
              snapshot.stackTrace);

            return Container(
                child: const Center(
                  child: Text(
                    "An internal error has occurred. ",
                    textDirection: TextDirection.ltr,
                  ),
                )
            );
          }

          if (snapshot.data == null
              || is_bad_response(snapshot.data!)){

            ReqResponse? temp = snapshot.data;

            return Container(
              child: Center(
                child: Text(
                    "An external error has occurred. "
        + ((temp!=null)? (temp.reasonPhrase ?? "null") : "snapshot data is null"),
                    textDirection: TextDirection.ltr,
                ),
              ),
            );
          }else{
            print("test");
            ReqResponse response = snapshot.data!;
            Map<String, dynamic> resulting_json = json.decode(response.body);
            List<dynamic> images_str = resulting_json['images'];
            List<Image> images = [];

            images_str.forEach((dynamic element_dynamic) {
              String element = element_dynamic;
              images.add(Image.network(
                  NETW_CONST.protocol + NETW_CONST.host + element));
            });

            assert (resulting_json['is_curr_client_the_owner'] is int);
            print("curr owner ${resulting_json['is_curr_client_the_owner'] }");
            print("your acc ${resulting_json['your_acc'] }");

            return HalamanTokoWrapper(
                scaffold_key: scaffold_key,
                child: HalamanTokoBody(
                    refresh_page: refresh_page,
                    scaffold_key: scaffold_key,
                    csrf_token: resulting_json['csrf_token'],
                    properties: HalamanTokoProperties(
                      id: widget.id,
                      is_curr_client_the_owner: resulting_json['is_curr_client_the_owner'] == 1,
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
                      proposal_server_path: resulting_json['alamat_proposal'],
                      owner: UserAccount(
                        full_name: resulting_json['owner']['full_name'],
                        username: resulting_json['owner']['username'],
                        photo_profile: Image.network(
                            NETW_CONST.protocol + NETW_CONST.host
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
          return Scaffold(
            key: scaffold_key,
            body: Container(
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
            ),
          );
        }
      },*/
    );
  }
}


class HalamanTokoWrapper extends StatelessWidget{
  final GlobalKey<ScaffoldState>? scaffold_key;
  final Widget child;
  HalamanTokoWrapper({required this.child, this.scaffold_key, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget temp_child = child;

    return SafeArea(
        child: Scaffold(
          key: scaffold_key,
          backgroundColor: STYLE_CONST.background_color,
          floatingActionButton: null,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10),
            child: temp_child,
          ),
      ),
      );
  }
}


class HalamanTokoInheritedWidget extends InheritedWidget{
  final Function(Function()) refresh_page;
  final GlobalKey<ScaffoldState>? scaffold_key;
  final HalamanTokoProperties properties;
  final Function(Function() func) setState;
  final String csrf_token;

  const HalamanTokoInheritedWidget({
    required this.refresh_page,
    required this.properties,
    required Widget child,
    required this.setState,
    required this.scaffold_key,
    required this.csrf_token,
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


class HalamanTokoRefreshInheritedWidget extends InheritedWidget{
  final Function(Function() func) refresh;

  const HalamanTokoRefreshInheritedWidget({
    required Widget child,
    required this.refresh,
    Key? key,
  }) : super(key: key, child: child);

  static HalamanTokoRefreshInheritedWidget of(BuildContext context){
    final HalamanTokoRefreshInheritedWidget? ret
    = context.dependOnInheritedWidgetOfExactType<HalamanTokoRefreshInheritedWidget>();
    assert (ret != null, 'HalamanTokoRefresh is not found in the context');
    return ret!;
  }

  @override
  bool updateShouldNotify(covariant HalamanTokoInheritedWidget old) {
    return false;
  }
}

