// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:bizzvest/halaman_toko/shared/loading_screen.dart';
import 'package:bizzvest/halaman_toko/shared/provider_matrial_app.dart';
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
    return ProviderMaterialApp(ManagePhoto(company_id: company_id,));
  }
}

class ManagePhoto extends StatelessWidget{
  final int company_id;


  ManagePhoto({required this.company_id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestLoadingScreenBuilder(
        request_function: () async {
          var auth = await get_authentication(context);
          var response = await auth.get(
            uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_manage_photos_init_api),
            data: {
              'id': this.company_id.toString(),
            }
          );
          return response;
        },

        wrapper: (Widget widget, RequestStatus req_stat){
          return Scaffold(
            body: widget,
            backgroundColor: STYLE_CONST.background_color,
          );
        },

        on_success: (context, snapshot, req_resp, refresh){
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

  List<ImageTile> photo_items = [];

  // must be locked while sending a request to prevent sending multiple
  // request at the same time
  bool _is_activity_locked = false;
  set is_activity_locked(bool value){
    setState((){
      _is_activity_locked = value;
    });
  }
  bool get is_activity_locked{
    return _is_activity_locked;
  }


  void initState() {
    super.initState();
    csrf_token = widget.initial_csrf;
    load_from_list_of_tuple(widget.initial_photo_items);

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
  void load_from_list_of_tuple(List<Tuple2<int, String>> image_list){
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
            on_double_tap: on_delete(element.item1),
          ),
        );

        counter++;
      });
    });
  }


  Function() on_delete(int image_id){
    return () async {
      if (is_activity_locked){
        show_snackbar(context, "Sorry, we're still working on previous task");
        return;
      }

      is_activity_locked = true;
      int photo_id = image_id;
      show_snackbar(context, "Sending delete request");

      Map<String, dynamic> data = {
        COOKIE_CONST.csrf_token_formdata: csrf_token,
        'photo_id': photo_id,
      };

      ReqResponse? response = null;
      try{
        var auth = await get_authentication(context);
        response = await auth.post(
          uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_delete_photo),
          data: data,
        );
      } on DioError catch(e){
        if (Session.is_timeout_error(e)){
          show_snackbar(context, "request timed out");
          return;
        }
        show_snackbar(context, "Internal dio error occurred");
        return;
      } finally {
        is_activity_locked = false;
      }

      if (response.has_problem){
        show_snackbar(context, "Error ${response.statusCode} ${response.body}");
        return;
      }

      List<dynamic> temp_list_1 = json.decode(response.body);
      List<Tuple2<int, String>> temp_list_2 = ManagePhoto.fetched_photo_list__to__list_of_tuple(temp_list_1);
      load_from_list_of_tuple(temp_list_2);

      show_snackbar(context, "The photo has been deleted successfully");
    };
  }

  Future<void> save_photo_order_to_server(BuildContext context) async {
    is_activity_locked = true;
    show_snackbar(context, "Saving photos order to server");

    Map<String, int> photo_order = {};
    for (int i=0; i<photo_items.length; i++){
      photo_order[photo_items[i].img_id.toString()] = i;
    }
    Map<String, dynamic> data = {
      COOKIE_CONST.csrf_token_formdata: csrf_token,
      'company_id': company_id.toString(),
      'photo_order': json.encode(photo_order),
    };

    ReqResponse? response = null;
    try{
      var auth = await get_authentication(context);
      response = await auth.post(
        uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_set_photos_order),
        data: data,
      );
    } on DioError catch(e){
      if (Session.is_timeout_error(e)){
        show_snackbar(context, "Failed to save photos order: request timed out");
        return;
      }
      show_snackbar(context, "Internal dio error");
      return;
    } finally {
      is_activity_locked = false;
    }

    if (response.has_problem){
      show_snackbar(context, "Error ${response.statusCode} ${response.body}");
      return;
    }

    show_snackbar(context, "Successfully saved photos order to server");
  }

  Function() on_user_tap_add_photo_button(BuildContext context){
    return () async {
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images == null){
        show_snackbar(context, "user didn't pick any image");
        if (kDebugMode)
          print("user cancelled upload");
      }

      is_activity_locked = true;
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

      var auth = await get_authentication(context);
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
      } finally {
        is_activity_locked = false;
      }

      if (resp.has_problem){
        if (resp.statusCode == 400){
          show_snackbar(context, "Error ${resp.statusCode}: ${resp.body}");
          return;
        }

        show_snackbar(context, "Error ${resp.statusCode} ${resp.statusMessage}");
        return;
      }

      List<dynamic> list_of_photo = json.decode(resp.data_string!);

      photo_items.clear();
      List<Tuple2<int, String>> temp = ManagePhoto.fetched_photo_list__to__list_of_tuple(list_of_photo);
      load_from_list_of_tuple(temp);

      show_snackbar(context, "uploaded successfully");
    };
  }

  @override
  Widget build(BuildContext context) {
    TextFormField berakhir_date;

    return
        Scaffold(
          key: _scaffold_key,
          floatingActionButton: FloatingActionButton(
            child: FaIcon(FontAwesomeIcons.plus),
            onPressed: is_activity_locked? null : on_user_tap_add_photo_button(context),
            backgroundColor: is_activity_locked? Colors.grey : Colors.blue,
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

                      onReorder: (oldIndex, newIndex) async {
                        if (is_activity_locked){
                          show_snackbar(context, "Sorry, we're still working on previous task");
                          return;
                        }

                        setState((){
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          photo_items.insert(newIndex, photo_items.removeAt(oldIndex));
                        });
                        await save_photo_order_to_server(context);
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