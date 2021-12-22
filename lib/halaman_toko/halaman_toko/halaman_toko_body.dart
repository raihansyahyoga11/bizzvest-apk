import 'dart:io';
import 'dart:ui';

import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'halaman_toko_properties.dart';


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
                          setState((){
                            is_download_proposal_enabled = false;
                          });

                          final download_url = CONSTANTS.protocol + CONSTANTS.server + properties.alamat_proposal!;
                          Directory? extDir;

                          final status = await Permission.storage.request();
                          if (status.isGranted){
                            extDir = await getExternalStorageDirectory();

                            if (extDir != null){
                              String download_path = '${extDir.path}/proposal ${properties.id} ${properties.nama_merek}.pdf';

                              final configuration = DownloaderUtils(
                                progressCallback: (current, total) {
                                  if (kDebugMode) {
                                    final progress = (current / total) * 100;
                                    print('Downloading: $progress');
                                  }
                                },
                                file: File(download_path),
                                progress: ProgressImplementation(),
                                onDone: () {
                                  OpenFile.open(download_path).then((val){
                                    if (kDebugMode)
                                      print("opened");
                                  });
                                  if (kDebugMode)
                                    print("done: " + download_path);
                                  setState((){
                                    is_download_proposal_enabled = true;
                                  });
                                },
                                deleteOnCancel: true,
                              );

                              await Flowder.download(download_url, configuration);
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
                status_verifikasi: HalamanTokoStatusContainer.get_widget_according_to_status(
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

  static Widget get_widget_according_to_status(int status){
    switch (status){
      case 0:
        return get_widget_for_value("belum mengajukan verifikasi");
      case 1:
        return get_widget_for_value("menunggu verifikasi");
      case 2:
        return get_widget_for_value("verifikasi ditolak");
      case 3:
        return get_widget_for_value("terverifikasi");
      default:
        assert (false);
        return get_widget_for_value("unknown error");
    }
  }

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

          ColouredHeaderText(
            "Deskripsi",
            textScaleFactor: headerTextScaleFactor,
          ),
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


