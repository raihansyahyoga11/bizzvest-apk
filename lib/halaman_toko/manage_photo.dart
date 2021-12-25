// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:bizzvest/halaman_toko/shared/loading_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:tuple/tuple.dart';


void main() {
  runApp(ManagePhotoMaterial(company_id: 8,));
}



class ManagePhotoMaterial extends StatelessWidget{
  final int company_id;
  const ManagePhotoMaterial({required this.company_id, Key? key}) : super(key: key);

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

      home: ManagePhoto(company_id: company_id,),
    );
  }
}

class ManagePhoto extends StatelessWidget{
  final int company_id;
  ManagePhoto({required this.company_id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestLoadingScreenBuilder(
        request: () async {
          var auth = await get_authentication();
          var response = await auth.get(
            uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_manage_photos_init_api),
            data: {
              'id': this.company_id.toString(),
            }
          );
          return response;
        }(),

        on_success: (context, snapshot, req_resp, refresh){
          print(req_resp.data);
          Map<String, dynamic> map = json.decode(req_resp.data);

          List<Tuple2<int, String>> initial_photo_items =
              fetched_photo_list__to__list_of_tuple(map['photos']);

          return ManagePhotoBody(
            company_id: company_id,
            initial_csrf: map['csrftoken'],
            initial_photo_items: initial_photo_items,
          );
        }
    );
  }

  static List<Tuple2<int, String>> fetched_photo_list__to__list_of_tuple(List<dynamic> fetched_photo_data){
    List<Tuple2<int, String>> ret = [];
    for (Map<String, dynamic> element in fetched_photo_data) {
      ret.add(Tuple2(
          element['id'], element['url']
      ));
    }
    return ret;
  }
}



class ManagePhotoBody extends StatefulWidget{
  final GlobalKey<ScaffoldState> _scaffold_key = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  final int company_id;
  final String initial_csrf;
  // id, url
  final List<Tuple2<int, String>> initial_photo_items;

  ManagePhotoBody({
    required this.company_id,
    required this.initial_csrf,
    required this.initial_photo_items,
    Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagePhotoBodyState();
}

class _ManagePhotoBodyState extends State<ManagePhotoBody>{
  GlobalKey<ScaffoldState> get _scaffold_key{
    return widget._scaffold_key;
  }
  ImagePicker get _picker{
    return widget._picker;
  }
  int get company_id{return widget.company_id;}
  late String csrf_token;

  List<Widget> photo_items = [];



  void initState() {
    super.initState();
    csrf_token = widget.initial_csrf;
    load_from_list(widget.initial_photo_items);

    // ibarat onLoad()
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scaffold_key == null || _scaffold_key.currentContext == null)
        return;


      show_snackbar(_scaffold_key.currentContext!,
              "Please long press and hold to reorder the images \n"
              + "Double tap to delete photos");
    });
  }


  // (img_id: int, img_url: string)
  void load_from_list(List<Tuple2<int, String>> image_list){
    setState(() {
      photo_items.clear();

      int counter = 0;
      image_list.forEach((Tuple2<int, String> element) {
        String url = "${NETW_CONST.protocol}${NETW_CONST.host}${element.item2}";
        photo_items.add(
          ImageTile(
            Image.network(url),
            img_id: element.item1,
            key: UniqueKey(),
            on_double_tap: on_delete(counter),
          ),
        );

        counter++;
      });
    });
  }


  Function() on_delete(int index){
    return (){
      if (kDebugMode) {
        print("delete");
      }
      setState(() {
        photo_items.removeAt(index);
      });
    };
  }

  void __add_photo(){

  }

  @override
  Widget build(BuildContext context) {
    TextFormField berakhir_date;

    return
        Scaffold(
          key: _scaffold_key,
          floatingActionButton: FloatingActionButton(
            child: FaIcon(FontAwesomeIcons.plus),
            onPressed: () async {
              final List<XFile>? images = await _picker.pickMultiImage();

              if (images == null){
                show_snackbar(context, "user didn't pick any image");
                if (kDebugMode)
                  print("user cancelled upload");
              }

              show_snackbar(context, "uploading images...");

              FormData form_data = FormData();

              {
                for (var file in images!) {
                  form_data.files.add(
                      MapEntry('img', await MultipartFile.fromFile(file.path)));
                }
                form_data.fields.add(
                    MapEntry('company_id', widget.company_id.toString())
                );
                form_data.fields.add(
                    MapEntry(COOKIE_CONST.csrf_token_formdata, csrf_token)
                );
              }

              var auth = await get_authentication();
              ReqResponse? resp = null;
              try{
                resp = await auth.post(
                    uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_add_photo),
                    form_data: form_data);
              } on DioError catch(e){
                if (Session.is_timeout_error(e)){
                  show_snackbar(context, "request timed out");
                  return;
                }
                show_snackbar(context, "unknown error");
                return;
              }

              if (resp.has_problem){
                print(resp.data_string);

                if (resp.statusCode == 400){
                  show_snackbar(context, "Error ${resp.statusCode}: ${resp.body}");
                  return;
                }

                show_snackbar(context, "Error ${resp.statusCode} ${resp.statusMessage}");
                return;
              }

              List<dynamic> list_of_photo = json.decode(resp.data_string!);
              setState(() {
                photo_items.clear();
                List<Tuple2<int, String>> temp = ManagePhoto.fetched_photo_list__to__list_of_tuple(list_of_photo);
                load_from_list(temp);
              });

              show_snackbar(context, "uploaded successfully");
            },
          ),
          body:
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: BorderedContainer(
                  Container(
                    margin: EdgeInsets.all(20),
                    child: ReorderableListView(
                      children: photo_items,

                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          photo_items.insert(newIndex, photo_items.removeAt(oldIndex));
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          backgroundColor: (Colors.lightBlue[200])!,

        );
  }
}




class FilteredImage extends StatelessWidget{
  ImageProvider<Object> img;
  ImageFilter image_filter = ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0);
  EdgeInsets padding;
  BoxFit fit;

  FilteredImage({
                 required this.img,
                 this.padding: const EdgeInsets.all(10),
                 ImageFilter? image_filter: null,
                 this.fit: BoxFit.cover,
               }){
    if (image_filter != null)
      this.image_filter = image_filter;
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: padding,
      child: Container(
          child: BackdropFilter(
            filter: image_filter,
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: img,
              fit: fit,
            ),
          )
      ),
    );
  }
}