// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:ui';

import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko_edit_description.dart';
import 'package:bizzvest/halaman_toko/manage_photo.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'halaman_toko_properties.dart';


class HalamanTokoBody extends StatefulWidget{
  Function(Function()) refresh_page;
  GlobalKey<ScaffoldState>? scaffold_key;
  final HalamanTokoProperties properties;
  final String csrf_token;

  HalamanTokoBody({
    required this.properties,
    required this.csrf_token,
    required this.refresh_page,
    Key? key,
    this.scaffold_key,
  }) : super(key: key);

  @override
  State<HalamanTokoBody> createState() => _HalamanTokoBodyState();
}

class _HalamanTokoBodyState extends State<HalamanTokoBody> {
  HalamanTokoProperties get properties{
    return widget.properties;
  }

  bool is_download_proposal_enabled = true;


  Widget build_photo_carousel(BuildContext context){
    bool show_edit_option = (properties.is_curr_client_the_owner && properties.status_verifikasi == 0);
    return BorderedContainer(
      Column(
        children:[
          // jika pengunjung saat ini adala
          if (show_edit_option)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(text: TextSpan(
                    style: DefaultTextStyle.of(context).style,  // apply default-nya
                    children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: on_tap_goto_manage_photo(context),
                            child: Icon(
                              FontAwesomeIcons.edit,
                              size: 24,
                              color: ColouredHeaderTextSpan(text:"").color,
                            ),
                          ),
                        ),
                    ]
                )),
                SizedBox(width: 10, height: 0,)
              ]
            ),

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
        ],
      ),
    );
  }

  Function() on_tap_goto_manage_photo(BuildContext context){
    HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);

    return (){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ManagePhoto(company_id: inh_widg.properties.id)))
          .then((value) => inh_widg.refresh_page((){}));
    };
  }

  Widget build_proposal_download_button(BuildContext context){
    return StatefulBuilder(
        builder: (context, setState) =>
            BorderedButtonIcon(
              on_pressed: download_proposal(context),
              is_disabled: !is_download_proposal_enabled,
              icon: const FaIcon(FontAwesomeIcons.book),
              label: const Text("Download Proposal"),
              margin: BorderedContainer.get_margin_static(),
            )
    );
  }

  Function() download_proposal(BuildContext context){
    return () async {
      setState((){
        is_download_proposal_enabled = false;
      });

      HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);
      HalamanTokoProperties properties = inh_widg.properties;
      Directory? extDir;
      // harus di deklarasikan ulang setiap kali di-klik, sebab bisa aja pengguna sudah
      // mengupload file baru tanpa me-refresh (tutup app lalu buka lagi).
      // Oleh karena itu, setiap mau download, linknya harus diupdate
      final download_url = NETW_CONST.protocol
          + NETW_CONST.host
          + properties.proposal_server_path!;

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
      }else{
        show_snackbar(context, "Sorry, we couldn't download the requested file because we have no permission to read-write storage");
      }
    };
  }


  @override
  Widget build(BuildContext context) {
    String jumlah_lembar_saham = thousand_separator(properties.jumlah_lembar_saham);
    String nilai_lembar_saham = thousand_separator(properties.nilai_lembar_saham);

    return
      HalamanTokoInheritedWidget(
          refresh_page: widget.refresh_page,
          properties: properties,
          setState: setState,
          scaffold_key: widget.scaffold_key,
          csrf_token: widget.csrf_token,

          child: Builder(builder: (context){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                HalamanTokoHeaderTitle(properties.nama_merek, properties.nama_perusahaan),
                build_photo_carousel(context),

                HalamanTokoOwnerContainer(
                    properties.owner.photo_profile,
                    properties.owner.full_name,
                    properties.owner.username
                ),

                HalamanTokoKodeSisaPeriode(),

                if (properties.proposal_server_path != null && properties.proposal_server_path != "")
                  build_proposal_download_button(context),

                HalamanTokoStatusContainer(
                  status_verifikasi: HalamanTokoStatusContainer.get_widget_according_to_status(
                      properties.status_verifikasi, context
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
            );
          })
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


class ColouredHeaderTextSpan extends TextSpan{
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final String text;
  final List<InlineSpan>? children;
  final GestureRecognizer? recognizer;
  final context;

  ColouredHeaderTextSpan({
    required this.text,
    this.context,
    this.children,
    this.recognizer,
    this.color = const Color.fromARGB(255, 7, 130, 159),
    this.fontWeight = FontWeight.bold,
    this.fontFamily = "Quicksand",
  }) : super(
  text: text,
  children: children,
  recognizer: recognizer,
  style: TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
  )
  );
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

  static Widget get_widget_according_to_status(int status,
      BuildContext context, {bool show_edit_option: true}){

    String extra_space_1 = "  ";
    String extra_space_2 = "      ";

    switch (status){
      case 0:
        return RichText(text: TextSpan(
            style: DefaultTextStyle.of(context).style,  // apply default-nya
            children: [
              WidgetSpan(
                child: get_widget_for_value("belum mengajukan" + extra_space_1, false)
              ),

              if (show_edit_option)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: on_user_tap_upload_proposal(context),
                    child: const Icon(
                      FontAwesomeIcons.fileUpload,
                      size: 22,
                      color: Colors.black,
                      // color: Color.fromARGB(255, 22, 149, 0),
                    ),
                  ),
                ),

              TextSpan(text: extra_space_2),

              if (show_edit_option)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: on_user_tap_submit_verification(context),
                    child: const Icon(
                      FontAwesomeIcons.fileExport,
                      size: 22,
                      color: Colors.black,
                      // color: Color.fromARGB(255, 22, 149, 0),
                    ),
                  ),
                ),


            ]
        ));
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

  static Function() on_user_tap_upload_proposal(BuildContext context) {
    HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);
    HalamanTokoProperties prop = inh_widg.properties;

    return () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.length == 0 || result.paths[0] == null){
        show_snackbar(context, "user didn't pick any proposal");
        return;
      }

      show_snackbar(context, "uploading...");

      var auth = await get_authentication();
      var response = await auth.post(
          uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_upload_proposal),
          data: {
            COOKIE_CONST.csrf_token_formdata: inh_widg.csrf_token,
            'company_id': prop.id,
            'proposal': await dio.MultipartFile.fromFile(result.paths[0]!),
          }
      );

      if (response.has_problem){
        ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error ${response.reasonPhrase}:  ${response.body} ")));
        return;
      }

      ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("uploaded successfully to the server")));
      inh_widg.setState((){
        prop.proposal_server_path = response.body;  // update the new URL for the proposal
      });  // refresh
    };
  }

  static Function() on_user_tap_submit_verification(BuildContext context) {

    HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);
    HalamanTokoProperties prop = inh_widg.properties;

    Future<void> kirim_verifikasi() async {
      ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mengajukan verifikasi")));

      var auth = await get_authentication();
      var response = await auth.post(
        uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_ajukan_verifikasi),
        data: {
          'id': prop.id,
          COOKIE_CONST.csrf_token_formdata: inh_widg.csrf_token,
        },
      );

      if (response.has_problem){
        ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error ${response.reasonPhrase}:  ${response.body} ")));
        return;
      }

      ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Berhasil mengajukan verifikasi")));

      inh_widg.refresh_page((){});
    };

    return () async {

      Function([int state])? func;
      func = ([int state=0]) async {
        SimplePrompt(
            const Text("Submit for verification"),
            Text("Apakah Anda benar-benar ingin mengajukan verifikasi?  "
                + ((state == 1)? "(sekali lagi)" : "") + "\n\n"
                + "Jika anda sudah mengajukan verifikasi, maka anda tidak akan "
                + "bisa mengubah informasi apapun lagi untuk kedepannya."),
            [
              SimplePromptAction("Cancel", () {
                Navigator.pop(context);
              }),
              SimplePromptAction("Tetap submit", () {
                Navigator.pop(context);

                if (state == 0)
                  func!(state + 1);
                else{
                  kirim_verifikasi();
                }
              }),
            ]
        ).show(context);
      };

      func();

    };
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

  static Widget get_widget_for_value(String str, [bool extra_wrapper=true]){
    Widget ret;

    ret = Align(
        alignment: Alignment.centerLeft,
        child: SelectableText(str,
      style: const TextStyle(
        fontFamily: 'arial',
      ),
      textScaleFactor: 0.85,
      textAlign: TextAlign.left,
    ));

    if (extra_wrapper) {
      ret = Container(
        child: ret,
        margin: EdgeInsets.symmetric(vertical: 6),
      );
    }

    return ret;
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
          get_widget_for_label("Status"),         Align(child:status_verifikasi),
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
    HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);
    HalamanTokoProperties prop = inh_widg.properties;

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

          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,  // apply default-nya
              children: [
                ColouredHeaderTextSpan(
                  text: 'Deskripsi',
                  context: context,
                ),

                TextSpan(text: "  "),

                // kalau belum mengajukan verifikasi dan pengunjung saat ini merupakan
                // pemilik dari toko itu sendiri
                if (prop.is_curr_client_the_owner && prop.status_verifikasi == 0)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                        onTap: on_user_tap_description_pencil_edit_button(context),
                        child: Icon(
                          FontAwesomeIcons.pencilAlt,
                          size: 20,
                          color: ColouredHeaderTextSpan(text:"").color,
                          // color: Color.fromARGB(255, 22, 149, 0),
                        ),
                      ),
                    ),
              ]
            ),
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

  static Function() on_user_tap_description_pencil_edit_button(BuildContext context) {
    HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);
    HalamanTokoProperties prop = inh_widg.properties;

    return () async {
      await goto_halaman_toko_edit_description(context,
          MaterialPageRoute(builder: (context){
            return HalamanTokoEditDeskripsi(initial_description: prop.deskripsi);
          })
      );
    };
  }

  static Future<void> goto_halaman_toko_edit_description(
        BuildContext context,
        Route<String> route,
      ) async {
    HalamanTokoInheritedWidget inh_widg = HalamanTokoInheritedWidget.of(context);
    HalamanTokoProperties prop = inh_widg.properties;

    String old_description = prop.deskripsi;
    String? new_description = await Navigator.push(context, route);

    if (new_description == null){
      if (kDebugMode)
        print("discarded");
      return;
    }

    print("new desc ${new_description}");

    inh_widg.setState((){
      prop.deskripsi = new_description;
    });


    BuildContext? curr_context =  inh_widg.scaffold_key?.currentContext;
    ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
    if (curr_context != null)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saving to server...")));


    // () async {
      var auth = await get_authentication();
      auth.cookie_jar.loadForRequest(NETW_CONST.get_server_URI("/"))
          .then(
                (List<Cookie> value){
                  print(value);
                }
              );

      try{
        ReqResponse resp = await auth.post(
            uri: NETW_CONST.get_server_URI(
                NETW_CONST
                    .halaman_toko_save_company_form),
            data: {
              COOKIE_CONST.csrf_token_formdata: inh_widg.csrf_token,
              'id': prop.id,
              'deskripsi': new_description
            }
        );

        if (resp.has_problem) {
          throw resp;
        }
        
        print("no problem");

        ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
        if (curr_context != null)
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
        return;

      } on ReqResponse catch(e){
        ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Connection error: " + (e.reasonPhrase ?? "null")))
        );
      } on Exception catch(e){
        SnackBar snackbar;

        if (Session.is_timeout_error(e)){
          snackbar = SnackBar(content: Text("Connection timed out"));
        }else{
          snackbar = SnackBar(content: Text("Error: " + e.toString()));
        }
        ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }

      // bagian ini hanya dijalankan kalau error.
      // kalau tidak error, kita return saja.
      goto_halaman_toko_edit_description(
          context,
          MaterialPageRoute(builder: (context){
            return HalamanTokoEditDeskripsi(
              initial_description: old_description,
              current_description: new_description,
            );
          })
      );
    // }();
  }
}


