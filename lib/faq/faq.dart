import 'dart:convert';
import 'package:bizzvest/daftar_toko/daftar_toko.dart';
import 'package:bizzvest/halaman_toko/add_toko/add_toko.dart';
import 'package:bizzvest/login_signup/cookie.dart';
import 'package:bizzvest/login_signup/signup.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:bizzvest/faq/api/api_faq.dart';
import 'package:bizzvest/faq/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'models/question.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

late Future<List<Question>?> futureQuestion = fetchQuestion();


class FaqUtamaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frequently Ask Question')),
        body: SafeArea(
            child: Container(
              color: Color(0xffdafcff),
              margin: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Color(0xffc3f1fc),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: new Center (
                              child: Text(
                                "FAQ",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xff374ABE),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                      ),
                    ),

                    SizedBox(height: 20.0),
                    MyApp(),
                    
                    
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return new StuffInTiles(listOfTiles[index]);
                    //   },
                    //   itemCount: listOfTiles.length,
                    // ),

                    Helper.verticalSpaceLarge(),
                    SizedBox(height: 20.0),
                    Center(
                      child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Color(0xffc3f1fc),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: new Center (
                              child: Text(
                                "Pertanyaan Lainnya",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xff374ABE),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                      ),
                    ),

                    SizedBox(height: 20.0),

                    FaqListScreen(),
                    Helper.verticalSpaceLarge(),
                    FormScreen()

                    ],
                  ),
                )
            )
        )
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      Padding(padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ExpansionTileCard(
              baseColor: Colors.white,
              title: new Text(
                  'Bagaimana cara mendaftarkan usaha di BizzVest?',
                  style: TextStyle(
                    color: Color(0xff374ABE),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              shadowColor: Color(0xff374ABE),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),

                SizedBox(height: 10),

                Center(
                  child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: new Center (
                          child: Text(
                            "Alur Pendaftaran Usaha di Bizzvest",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                      )
                  ),
                ),

                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-1-step-1.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Buat akun di BizzVest terlebih dahulu pada halaman sign up.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),


                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 2',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-1-step-2.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Masukkan data usaha yang anda miliki, seperti nama usaha, deskripsi usaha, jumlah dan nilai lembar saham, serta dividen dan batas waktu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 3',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-1-step-3.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Anda dapat memasukkan foto-foto dan proposal usaha pada halaman toko agar nantinya dapat meyakinkan investor untuk berinvestasi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 4',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-1-step-4.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Tunggu usaha Anda selesai diverifikasi oleh administrator BizzVest selama 3-5 hari kerja.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.all(15.0),

                    color: Color(0xff3d51ff),
                    hoverColor: Color(0xff3e69e3),

                    onPressed: () async {
                      CookieRequest request = Provider.of<CookieRequest>(context);
                      if (!request.loggedIn) {
                        // kondisi untuk user yang belum login

                        Alert(
                          context: context,
                          type: AlertType.none,
                          title: "DAFTARKAN USAHA",
                          desc: "Anda belum masuk ke dalam akun BizzVest. Silahkan sign up atau sign in terlebih dahulu sebelum mendaftarkan usaha.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff6f6f6f),
                            ),
                            DialogButton(
                              child: Text(
                                "Sign Up Sekarang",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff3d51ff),
                            )
                          ],
                        ).show();
                      } else {
                        // kondisi untuk user yang sudah login

                        Alert(
                          context: context,
                          type: AlertType.none,
                          title: "DAFTARKAN USAHA",
                          desc: "Apakah Anda ingin mendaftarkan usaha yang Anda miliki?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff6f6f6f),
                            ),
                            DialogButton(
                              child: Text(
                                "Daftar Sekarang",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff3d51ff),
                            )
                          ],
                        ).show();
                      }


                    },
                    child: Text(" Daftarkan Usaha ",
                        style: TextStyle(
                      // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0
                      )
                    )
                ),

                SizedBox(height: 20.0),
              ],
            ),

            SizedBox(height: 16.0),

            ExpansionTileCard(
              baseColor: Colors.white,
              title: new Text(
                'Bagaimana cara berinvestasi di BizzVest?',
                style: TextStyle(
                  color: Color(0xff374ABE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              shadowColor: Color(0xff374ABE),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),

                SizedBox(height: 10),

                Center(
                  child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: new Center (
                          child: Text(
                            "Alur Investasi di Bizzvest",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                      )
                  ),
                ),

                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-1-step-1.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Buat akun di BizzVest terlebih dahulu pada halaman sign up.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),


                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 2',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-2-step-2.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Pilih usaha yang ingin anda berikan investasi dengan melihat deskripsi dan proposal dari usaha tersebut.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 3',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-2-step-3.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Berikan investasi sesuai dengan nominal nilai lembar saham dan banyaknya lembar saham yang Anda inginkan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

                Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    borderOnForeground: false,
                    color: Color(0xffe9faff),
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Langkah 4',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 15),

                        Image.asset('src/img/faq-2-step-4.png', width: 75, height: 75),

                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child:Text(
                            'Analisis laporan keuangan usaha sambil menantikan dividen yang akan anda terima pada batas waktu yang telah ditentukan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.all(15.0),

                    color: Color(0xff3d51ff),
                    hoverColor: Color(0xff3e69e3),

                    onPressed: () async {
                      CookieRequest request = Provider.of<CookieRequest>(context);
                      if (!request.loggedIn) {
                        // kondisi untuk user yang belum login

                        Alert(
                          context: context,
                          type: AlertType.none,
                          title: "MULAI INVESTASI",
                          desc: "Anda belum masuk ke dalam akun BizzVest. Silahkan sign up atau sign in terlebih dahulu sebelum mulai investasi.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff6f6f6f),
                            ),
                            DialogButton(
                              child: Text(
                                "Sign Up Sekarang",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff3d51ff),
                            )
                          ],
                        ).show();
                      } else {
                        // kondisi untuk user yang sudah login

                        Alert(
                          context: context,
                          type: AlertType.none,
                          title: "MULAI INVESTASI",
                          desc: "Apakah Anda ingin memberikan investasi untuk pemilik UMKM/petani?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff6f6f6f),
                            ),
                            DialogButton(
                              child: Text(
                                "Investasi Sekarang",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 80,
                              color: Color(0xff3d51ff),
                            )
                          ],
                        ).show();
                      }


                    },
                    child: Text(" Mulai Investasi ",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0
                        )
                    )
                ),

                SizedBox(height: 20.0),
              ],
            ),

            SizedBox(height: 16.0),
            ExpansionTileCard(
              baseColor: Colors.white,
              title: new Text(
                'Berapa lama hasil investasi atau dividen didapatkan?',
                style: TextStyle(
                  color: Color(0xff374ABE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              shadowColor: Color(0xff374ABE),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                        "Hasil investasi pembagian keuntungan saham akan didapatkan sesuai dengan kesepakatan antara pelaku UMKM/petani dengan investor sejak awal.",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),
            ExpansionTileCard(
              baseColor: Colors.white,
              title: new Text(
                'Berapa lama menunggu investor memberikan modal?',
                style: TextStyle(
                  color: Color(0xff374ABE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              shadowColor: Color(0xff374ABE),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "Tidak dapat dipastikan lamanya waktu untuk mendapatkan modal dari investor. BizzVest hanya menjadi perantara antara pelaku UMKM/petani dengan investor. Namun, pelaku UMKM/petani dapat memberikan video profil, proposal, atau penawaran keuntungan investasi yang menarik minat investor. Usaha tersebut diharapkan dapat memperbesar kemungkinan mendapatkan modal dari investor.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),
            ExpansionTileCard(
              baseColor: Colors.white,
              title: new Text(
                'Kenapa harus bergabung dengan BizzVest?',
                style: TextStyle(
                  color: Color(0xff374ABE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              shadowColor: Color(0xff374ABE),
              children: const <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "BizzVest hadir sebagai perantara bagi pelaku bisnis seperti pemilik UMKM (Usaha Mikro, Kecil, dan Menengah) dan petani untuk mendapatkan modal usaha dari para investor agar dapat melanjutkan bisnis mereka. Siapapun dapat bertindak sebagai penerima atau pemberi modal sesuai dengan ketentuan yang berlaku.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 3.0,
                    ),
                    child: Text(
                      "• Pelaku UMKM/petani",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 39.0,
                      vertical: 1.0,
                    ),
                    child: Text(
                      "Pelaku UMKM/petani akan mendapatkan tambahan modal untuk melanjutkan usaha mereka terutama di masa pandemi Covid-19 seperti ini.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 3.0,
                    ),
                    child: Text(
                      "• Investor",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 39.0,
                      vertical: 1.0,
                    ),
                    child: Text(
                      "Investor dapat memilih tempat mereka akan berinvestasi saham dengan praktis di BizzVest dan mendapatkan pendapatan pasif sebagai hasil investasi tanpa harus terlibat dengan kegiatan operasional usaha.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            )
          ],
        ),

      );

  }

  // function to login
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupForm()));
  }

  // function to daftar toko
  void _navigateToDaftarTokoScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaftarTokoMaterial()));
  }

  // function to add toko
  void _navigateToAddTokoScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddToko()));
  }
}


class FaqListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureQuestion,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Question is Empty'),
          );
        } else if (snapshot.hasData) {
          return _listFAQ(snapshot.data as List<Question>);
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _listFAQ(List<Question> questions) {
    double field = 75;
    return Container(
      height: field * questions.length,
      child: ListView.builder(
            itemCount: questions.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var question = questions[index].fields;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text(question!.pertanyaan, textAlign: TextAlign.left, style: TextStyle(fontSize: 17, color: Color(0xff374ABE), fontWeight: FontWeight.bold)),
                          Text("Pertanyaan dari " + question.nama, textAlign: TextAlign.left, style: TextStyle(fontSize: 17, color: Color(0xff374ABE))),
                        ],
                      )
                  ),
                )
              );
            },
        ),
    );
  }

}



class FormScreen extends StatelessWidget {
  String nama = '';
  String pertanyaan = '';

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Center(
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Color(0xffc3f1fc),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: new Center (
                        child: Text(
                          "Ada Pertanyaan?",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Color(0xff374ABE),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                    )
                ),
            ),

            SizedBox(height: 20.0),

            new Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 1.0, bottom: 8.0, start: 16.0, end: 16.0),
                child: Text(
                  "Nama:",
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff374ABE)),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onChanged: (String value) {
                        nama = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Tuliskan nama Anda...",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.3, color: Colors.blue),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    )
                  ],
                ),

              ),
            ),

            new Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 25.0, bottom: 8.0, start: 16.0, end: 16.0),
                child: Text(
                  "Pertanyaan:",
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff374ABE)),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onChanged: (String value) {
                        pertanyaan = value;
                      },
                      maxLines: 7,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Tuliskan pertanyaan Anda...",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.3, color: Colors.blue),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    )
                  ],
                ),

              ),
            ),

            SizedBox(height: 20.0),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.all(15.0),

                color: Color(0xff78d9ea),
                hoverColor: Color(0xff9decf6),

                onPressed: () async {
                  final response = await http.post(Uri.parse('http://127.0.0.1:8000/faq/json/'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                      body: jsonEncode(<String, String>{
                        'nama': nama,
                        'pertanyaan': pertanyaan,
                      }));
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FaqUtamaScreen()),
                  );
                  futureQuestion = fetchQuestion();
                },
                child: Text(" Kirimkan pertanyaan ", style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17.0
                ))
            ),
            SizedBox(height: 20.0),
          ],
        );
  }
}
