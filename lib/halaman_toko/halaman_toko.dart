// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:bizzvest/halaman_toko/configurations.dart';
import 'package:bizzvest/halaman_toko/shared.dart';
import 'package:bizzvest/halaman_toko/dependencies_related.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bizzvest/halaman_toko/user_account.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await initialize();
  runApp(const HalamanToko(id:7));
}




Future<void> initialize() async {
  await ensure_flutter_downloader_is_initialized();
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
            ));;
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

            return HalamanTokoWrapper(
                child: HalamanTokoBody(
                    HalamanTokoProperties(
                      nama_merek: resulting_json['nama_merek'],
                      nama_perusahaan: resulting_json['nama_perusahaan'],
                      images: images,
                      status_verifikasi: resulting_json['status_verifikasi'].toString(),
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
  final Widget? child;
  const HalamanTokoWrapper({this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? temp_child = child;

    temp_child ??= HalamanTokoBody(HalamanTokoProperties(
      nama_merek: "Bizzvest",
      nama_perusahaan: "PT. Bizzvest Indonesia",
      images: [
        Image.asset("src/img/img1.jpg"),
        Image.asset("src/img/kecil.png"),
        Image.asset("src/img/img3.jpg"),
        Image.asset("src/img/profile.jpg"),
      ],
      status_verifikasi: "belum mengajukan tes tes tes",
      tanggal_berakhir: "01 Jan 2024",

      kode_saham: "RAZE",
      sisa_waktu: "2 tahun",
      periode_dividen: "12 bulan",
      alamat: "jalan pepaya",
      deskripsi: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vel leo nunc. Etiam vitae ligula vitae arcu maximus tincidunt vitae et velit. Mauris velit quam, venenatis quis viverra ultrices, viverra sit amet purus. Curabitur nec tempus velit. Integer vehicula elit vel augue fringilla, vitae dignissim dui viverra",
      alamat_proposal: "",
      owner: UserAccount(
        full_name: 'Kugel Blitz',
        username: 'hzz',
        photo_profile: Image.asset("src/img/profile.jpg"),
      ),

      nilai_lembar_saham: 400 * 1000,
      jumlah_lembar_saham: 400 * 1000,
      jumlah_lembar_saham_tersisa: 100 * 1000,
    ));

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

class HalamanTokoProperties{
  final String nama_merek;
  final String nama_perusahaan;
  final List<Image> images;

  final String status_verifikasi;
  final String tanggal_berakhir;
  final String kode_saham;
  final String sisa_waktu;
  final String periode_dividen;
  final String alamat;
  final String deskripsi;
  final String? alamat_proposal;

  final UserAccount owner;

  final int jumlah_lembar_saham;
  final int jumlah_lembar_saham_tersisa;
  final int nilai_lembar_saham;

  double get persen_saham_tersisa => 100*jumlah_lembar_saham_tersisa / jumlah_lembar_saham;
  int get total_nilai_saham_tersisa => jumlah_lembar_saham_tersisa * nilai_lembar_saham;

  double get persen_saham_terjual => 100*jumlah_lembar_saham_terjual / jumlah_lembar_saham;
  int get jumlah_lembar_saham_terjual => jumlah_lembar_saham - jumlah_lembar_saham_tersisa;
  int get total_nilai_saham_terjual => nilai_lembar_saham * jumlah_lembar_saham_terjual;


  HalamanTokoProperties({
    required this.nama_merek,
    required this.nama_perusahaan,
    required this.images,
    required this.status_verifikasi,
    required this.tanggal_berakhir,
    required this.alamat,
    required this.deskripsi,
    required this.alamat_proposal,
    required this.owner,

    required this.kode_saham,
    required this.sisa_waktu,
    required this.periode_dividen,

    required this.jumlah_lembar_saham,
    required this.nilai_lembar_saham,
    required this.jumlah_lembar_saham_tersisa,
  });



  @override
  bool operator ==(Object other) {
    if (other is! HalamanTokoProperties) {
      return false;
    }
    if (identityHashCode(this) == identityHashCode(other)) {
      return true;
    }
    HalamanTokoProperties o = other;
    return nama_merek == o.nama_merek
        && deskripsi == o.deskripsi
        && alamat_proposal == o.alamat_proposal
        && alamat == o.alamat
        && nama_perusahaan == o.nama_perusahaan
        && images == o.images
        && status_verifikasi == o.status_verifikasi
        && tanggal_berakhir == o.tanggal_berakhir
        && kode_saham == o.kode_saham
        && sisa_waktu == o.sisa_waktu
        && periode_dividen == o.periode_dividen
        && jumlah_lembar_saham == o.jumlah_lembar_saham
        && nilai_lembar_saham == o.nilai_lembar_saham
        && jumlah_lembar_saham_tersisa == o.jumlah_lembar_saham_tersisa
        && owner == o.owner
    ;
  }

  @override
  int get hashCode =>
      nama_merek.hashCode
      ^ nama_perusahaan.hashCode
      ^ alamat.hashCode
      ^ deskripsi.hashCode
      ^ alamat_proposal.hashCode
      ^ images.hashCode
      ^ status_verifikasi.hashCode
      ^ tanggal_berakhir.hashCode
      ^ kode_saham.hashCode
      ^ sisa_waktu.hashCode
      ^ periode_dividen.hashCode
      ^ jumlah_lembar_saham.hashCode
      ^ nilai_lembar_saham.hashCode
      ^ jumlah_lembar_saham_tersisa.hashCode
      ^ owner.hashCode
  ;
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



class HalamanTokoBody extends StatefulWidget{
  final HalamanTokoProperties properties;
  const HalamanTokoBody(this.properties, {Key? key}) : super(key: key);

  @override
  State<HalamanTokoBody> createState() =>
      _HalamanTokoBodyState(properties:properties);
}

class _HalamanTokoBodyState extends State<HalamanTokoBody> {
  final HalamanTokoProperties properties;
  _HalamanTokoBodyState({required this.properties});


  @override
  Widget build(BuildContext context) {
    String jumlah_lembar_saham = thousand_separator(properties.jumlah_lembar_saham);
    String nilai_lembar_saham = thousand_separator(properties.nilai_lembar_saham);
    bool is_download_proposal_enabled = true;

    return
      HalamanTokoInheritedWidget(properties: properties, setState: setState,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          HalamanTokoHeaderTitle(properties.nama_merek, properties.nama_perusahaan),

          BorderedContainer(
            AspectRatio(
                aspectRatio: 1 / 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  child: CarouselSlider.builder(
                    itemCount: properties.images.length,
                    options: CarouselOptions(
                      aspectRatio: 1/1,
                      viewportFraction: 1,
                      autoPlay: (properties.images.length > 1),
                      autoPlayInterval: const Duration(seconds: 4),
                    ),


                    itemBuilder: (context, index, realIndex) {
                      return ImageTile(
                          properties.images[index],

                          inner_wrapper: (context, image){
                            return Container(
                                child: AspectRatio(aspectRatio: 1/1,
                              child: image,),
                            );
                          },

                        outter_wrapper: (context, image){
                            return image;
                        },
                      );
                    },

                  ),
                )
            ),
          ),
          HalamanTokoOwnerContainer(
              properties.owner.photo_profile,
              properties.owner.full_name,
              properties.owner.username
          ),
          HalamanTokoKodeSisaPeriode(),
          (properties.alamat_proposal == null
           || properties.alamat_proposal == "")?
              const SizedBox(width:0, height:0) : StatefulBuilder(
                  builder: (context, setState) =>
                      BorderedButtonIcon(
                        on_pressed: () async {

                          // is_download_proposal_enabled = false;
                          // setState((){});

                          final download_url = CONSTANTS.protocol + CONSTANTS.server + properties.alamat_proposal!;
                          Directory? extDir;

                          final status = await Permission.storage.request();
                          if (status.isGranted){

                              extDir = (await getExternalStorageDirectory());
                              if (extDir != null){
                                String download_path = extDir.path;

                                await FlutterDownloader.enqueue(
                                  url: "https://png.pngtree.com/thumb_back/fw800/back_pic/03/91/36/7257dfa8e8e7297.jpg",
                                  savedDir: download_path,
                                  showNotification: true,
                                  openFileFromNotification: true,
                                );


                              }
                            ;
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content:
                                Text("Sorry, we couldn't download the requested file because we have no permission to read-write storage")
                                ));
                          }
                        },
                        is_disabled: !is_download_proposal_enabled,
                        icon: const FaIcon(FontAwesomeIcons.book),
                        label: const Text("Download Proposal"),
                        margin: BorderedContainer.get_margin_static(),
                      )
              ),

          HalamanTokoStatusContainer(
            status_verifikasi: HalamanTokoStatusContainer.get_widget_for_value(
                properties.status_verifikasi
            ),
            tanggal_berakhir: properties.tanggal_berakhir,
            jumlah_lembar_saham: jumlah_lembar_saham,
            nilai_lembar_saham: nilai_lembar_saham,
          ),

          BorderedContainer(
              HalamanTokoKondisiSaham()
          ),
          BorderedContainer(
              HalamanTokoAlamatDeskripsi()
          )
        ],
      )
      );
  }
}

class HalamanTokoHeaderTitle extends StatelessWidget{
  final String nama_merek;
  final String nama_perusahaan;

  const HalamanTokoHeaderTitle(this.nama_merek, this.nama_perusahaan);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 5),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: SelectableText(
              this.nama_merek,
              textScaleFactor: 1.8,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 14, 99, 223),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: SelectableText(
              this.nama_perusahaan,
              textScaleFactor: 1.05,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 108, 117, 125),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ColouredHeaderText extends StatelessWidget{
  final double textScaleFactor;
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final String text;

  const ColouredHeaderText(this.text, {
    this.color = const Color.fromARGB(255, 7, 130, 159),
    this.fontWeight = FontWeight.bold,
    this.fontFamily = "Quicksand",
    this.textScaleFactor = 1.0,
  });


  TextStyle get_text_style(){
    return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: get_text_style(),
      textScaleFactor: textScaleFactor,
    );
  }

}



class HalamanTokoOwnerContainer extends StatelessWidget{
  final Image foto_profile;
  final String nama_lengkap;
  final String username;

  HalamanTokoOwnerContainer(this.foto_profile, this.nama_lengkap,
      this.username);

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(1),
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: foto_profile.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    nama_lengkap,
                    textScaleFactor: 1.35,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 14, 99, 223),
                    ),
                  ),
                  SelectableText(
                    "@" + username,
                    textScaleFactor: 1.1,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 108, 117, 125),
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}


class HalamanTokoKodeSisaPeriode extends StatelessWidget{
  const HalamanTokoKodeSisaPeriode({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    HalamanTokoProperties prop = HalamanTokoInheritedWidget.of(context).properties;

    return BorderedContainer(
        Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 0,
              childAspectRatio: 2.8/1,
              shrinkWrap: true,
              children:
                  HalamanToko_KodeSisaPeriodeCell.juduls([
                    "kode saham", "sisa waktu", "periode dividen"
                  ]) +

                  HalamanToko_KodeSisaPeriodeCell.values([
                    prop.kode_saham, prop.sisa_waktu, prop.periode_dividen
                  ]),
            )
        )
    );
  }
}

class HalamanTokoStatusContainer extends StatelessWidget{
  final Widget status_verifikasi;
  final String tanggal_berakhir;
  final String jumlah_lembar_saham;
  final String nilai_lembar_saham;

  const HalamanTokoStatusContainer({
    required this.status_verifikasi,
    required this.tanggal_berakhir,
    required this.jumlah_lembar_saham,
    required this.nilai_lembar_saham
  });

  static Widget get_widget_for_label(String str){
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child:
        SelectableText(str,
          style: const TextStyle(
            fontFamily: 'arial',
          ),
          textScaleFactor: 0.85,
          textAlign: TextAlign.left,
        ),
      ),
      margin: EdgeInsets.only(right: 7,),
    );
  }

  static Widget get_widget_for_value(String str){
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child:
        SelectableText(str,
          style: const TextStyle(
            fontFamily: 'arial',
          ),
          textScaleFactor: 0.85,
          textAlign: TextAlign.left,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      LayoutGrid(
        columnSizes: [auto, 1.fr],
        rowSizes: const [
          auto, auto, auto, auto,
        ],

        children: [
          get_widget_for_label("Status"),         status_verifikasi,
          get_widget_for_label("Berakhir pada"),  get_widget_for_value(tanggal_berakhir),
          get_widget_for_label("Jumlah saham"),   get_widget_for_value("$jumlah_lembar_saham lembar"),
          get_widget_for_label("Harga saham"),    get_widget_for_value("Rp$nilai_lembar_saham,00"),
        ],

      ),

      /*HalamanTokoTabularData(
                  lines: [
                    "Status", properties.status_verifikasi,
                    "Berakhir pada", properties.tanggal_berakhir,
                    "Jumlah saham", "$jumlah_lembar_saham lembar",
                    "Harga saham", "Rp$nilai_lembar_saham,00",
                  ])*/
    );
  }
}


class HalamanToko_KodeSisaPeriodeCell{
  static List<Widget> juduls(List<String> judul) {
    return [
    for (var i=0; i < judul.length; i+=1)
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 3),
        child: Text(judul[i],
          textScaleFactor: 0.72,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 155, 155, 155),
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      ];
  }

  static List<Widget> values(List<String> nilai) {
    return [
      for (var i=0; i < nilai.length; i+=1)
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 4),
        child: SelectableText(nilai[i],
          textScaleFactor: 1.15,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 69, 0),
            fontFamily: 'Quicksand',
          ),
        ),
      ),
    ];
  }
}

String thousand_separator(int integer, [String separator = '.']){
  assert (separator.length == 1);
  return add_char_from_right(integer.toString(), separator, 3, repeat: true);
}

String add_char_from_right(String string, String character, int position, {bool repeat=false}){
  assert (character.length == 1);
  string = StringUtils.reverse(string);
  string = StringUtils.addCharAtPosition(string, character, position,
      repeat:repeat);
  string = StringUtils.reverse(string);
  return string;
}

class HalamanTokoKondisiSaham extends StatelessWidget {
  /*String length_controller(int nilai){
    // jika nilainya terlalu besar, maka akan diubah jadi kata-kata
    return "";
  }*/

  @override
  Widget build(BuildContext context) {
    HalamanTokoProperties prop = HalamanTokoInheritedWidget.of(context).properties;
    // var two_digit_floating = NumberFormat("###.0#", "en_US");
    String persen_terjual = prop.persen_saham_terjual.toStringAsFixed(2);
    String persen_tersisa = prop.persen_saham_tersisa.toStringAsFixed(2);
    String lembar_terjual = thousand_separator(prop.jumlah_lembar_saham_terjual);
    String lembar_tersisa = thousand_separator(prop.jumlah_lembar_saham_tersisa);
    String nilai_terjual  = thousand_separator(prop.total_nilai_saham_terjual);
    String nilai_tersisa  = thousand_separator(prop.total_nilai_saham_tersisa);


    return Column(
      children: [
        HalamanTokoTabularData(
            child_aspect_ratio: 5/1,
            header_left: const Align(
              alignment: Alignment.centerLeft,
              child: ColouredHeaderText("Saham Tersisa"),
            ),

            header_right: const Align(
              alignment: Alignment.centerLeft,
              child:  ColouredHeaderText("Saham Terjual"),
            ),

            lines: [
               "$persen_tersisa %", "$persen_terjual %",
              "$lembar_tersisa lembar", "$lembar_terjual lembar",
              "Rp$nilai_tersisa", "Rp$nilai_terjual",
            ]),

        Container(
          margin: EdgeInsets.only(top: 14, bottom: 7),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              minHeight: 10,
              backgroundColor: Color.fromARGB(255, 212, 212, 212),
              color: Color.fromARGB(255, 13, 202, 240),
              value: double.parse(persen_terjual)/100,
            ),
          ),
        ),
      ],
    );
  }
}



class HalamanTokoTabularData extends StatelessWidget{
  final List<String> list;
  final TextStyle text_style;
  final double text_scale_factor;
  final double child_aspect_ratio;
  final TextAlign text_align;
  final Alignment cell_alignment;
  final Widget? header_left;
  final Widget? header_right;

  HalamanTokoTabularData({
    required List<String> lines,
    TextStyle text_style = const TextStyle(
      fontFamily: 'arial',
    ),
    TextAlign text_align = TextAlign.left,
    Alignment alignment = Alignment.centerLeft,
    double text_scale_factor = 0.85,
    double child_aspect_ratio = 4.7/1,

    Widget? header_left =null,
    Widget? header_right =null,

  }) : list = lines, text_style = text_style, text_scale_factor=text_scale_factor,
        text_align=text_align, cell_alignment=alignment,  header_left=header_left,
        header_right=header_right, child_aspect_ratio=child_aspect_ratio;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        childAspectRatio: child_aspect_ratio,

        shrinkWrap: true,
        children:
            ((header_left==null)? <Widget>[]:<Widget>[header_left!]) +
            ((header_right==null)? <Widget>[]:<Widget>[header_right!]) +

            <Widget>[
                for (var i=0; i < list.length; i++)
                  Align(
                    alignment: cell_alignment,
                    child:
                    SelectableText(list[i],
                      style: text_style,
                      textScaleFactor: text_scale_factor,
                      textAlign: text_align,

                    ),
                  )
            ],

    );
  }
}

class HalamanTokoAlamatDeskripsi extends StatelessWidget{
  final double headerTextScaleFactor = 1.2;
  final double left_margin = 15;
  final double right_margin = 5;

  @override
  Widget build(BuildContext context) {
    HalamanTokoProperties prop = HalamanTokoInheritedWidget.of(context).properties;
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColouredHeaderText("Alamat", textScaleFactor: headerTextScaleFactor,),
          Container(  // dummy container
            margin: EdgeInsets.all(4),
          ),
          Container(
              margin: EdgeInsets.only(left: left_margin, right: right_margin),
              child: SelectableText(
                prop.alamat,
                textAlign: TextAlign.justify,
              )
          ),

          Container(  // dummy container
            margin: EdgeInsets.all(15),
          ),

          ColouredHeaderText("Deskripsi", textScaleFactor: headerTextScaleFactor,),
          Container(  // dummy container
            margin: EdgeInsets.all(4),
          ),
          Container(
              margin: EdgeInsets.only(left: left_margin, right: right_margin),
              child: SelectableText(
                prop.deskripsi,
                textAlign: TextAlign.justify,
              )
          ),
        ],
      ),
    );
  }
}




class BorderedButtonIcon extends StatelessWidget{
  final Function()? on_pressed;
  final bool is_disabled;
  final Text label;
  final Widget icon;
  final EdgeInsets margin;
  final EdgeInsets padding;
  // final Border border;

  BorderedButtonIcon({Key? key,
    required this.on_pressed,
    this.icon = const FaIcon(FontAwesomeIcons.book),
    this.label = const Text("Download Proposal", textScaleFactor: 1.2),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
    this.padding = const EdgeInsets.all(10.0),
    this.is_disabled = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
          child: ElevatedButton.icon(
            onPressed: this.is_disabled? null:this.on_pressed,
            label: label,
            style: const ButtonStyle(
              alignment: Alignment.centerLeft,
            ),
            icon: Padding(
              child: icon,
              padding: get_padding(),
            ),
          ),
      margin: get_margin(),
    );
  }

  EdgeInsets get_padding(){
    return padding;
  }
  EdgeInsets get_margin(){
    return margin;
  }
}


class ColouredBorderedContainer extends BorderedContainer{
  final Color bg_color;
  ColouredBorderedContainer(Widget child, {
    Color bg_color=const Color.fromARGB(255, 14, 109, 254)
  }) : bg_color=bg_color, super(child);

  @override
  Color get_bg_color() {
    return bg_color;
  }
}


class BorderedContainer extends StatelessWidget{
  BorderedContainer(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: child,
          padding: get_padding(),
          margin: get_margin(),
          decoration: get_box_decoration(),
    );
  }

  EdgeInsets get_padding(){
    return get_padding_static();
  }

  static EdgeInsets get_padding_static(){
    return EdgeInsets.all(10.0);
  }

  EdgeInsets get_margin(){
    // return EdgeInsets.zero;
    return get_margin_static();
  }

  static EdgeInsets get_margin_static(){
    // return EdgeInsets.zero;
    return EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0);
  }

  Color get_bg_color(){
    return get_bg_color_static();
  }

  static Color get_bg_color_static(){
    return Colors.white.withOpacity(0.75);
  }

  List<BoxShadow> get_box_shadows(){
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.4),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(1, 1), // changes position of shadow
      )
    ];
  }


  Border get_border() {
    return Border.all(
      color: Colors.white,
    );
  }

  BorderRadius get_border_radius() {
    return BorderRadius.all(Radius.circular(10));
  }

  BoxDecoration get_box_decoration(){
    return BoxDecoration(
      color: get_bg_color(),
      border: get_border(),

      boxShadow: get_box_shadows(),
      borderRadius: get_border_radius(),
    );
  }
}