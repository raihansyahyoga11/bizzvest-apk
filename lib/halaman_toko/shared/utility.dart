import 'dart:async';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/login_signup/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../manage_photo.dart';


bool develop_mode = false;
final String login_push_name = "/login_page_tito";

Future<void> init_authenticated_user() async {
  authenticated_user ??= await Authentication.create();
}


Authentication? authenticated_user = null;
Future<Authentication> get_authentication(BuildContext context) async {
  authenticated_user ??= await Authentication.create();
  if (!(authenticated_user!.is_logged_in)){
    if (develop_mode) {
      await authenticated_user!.login("hzz", "1122");
      assert (authenticated_user!.is_logged_in);
    }else{
      goto_login_page(context);
    }
  }
  return authenticated_user!;
}

bool is_authenticated(){
  if (authenticated_user != null)
    return authenticated_user!.is_logged_in;
  return false;
}

Future<void> set_authentication(String session_id) async {
  authenticated_user ??= await Authentication.create();
  await authenticated_user!.set_session_id(session_id);
  assert (authenticated_user!.is_logged_in);
  if (kDebugMode)
    print("set_authentication() success");
}

bool login_page_semaphore_unlocked = true;
Future<dynamic>? goto_login_page(BuildContext context){

  if (login_page_semaphore_unlocked) {

    return Future<dynamic>.microtask(() async {
      login_page_semaphore_unlocked = false;
      var ret = await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginForm();
      }));
      login_page_semaphore_unlocked = true;
      return ret;
    });

  }
}


bool is_bad_status_code(int status_code){
  return status_code < 200 || status_code >= 400;
}

bool is_bad_response(ReqResponse response){
  return response.statusCode == null || is_bad_status_code(response.statusCode!);
}

T? cast<T>(x) => x is T ? x : null;


void show_snackbar(BuildContext context, String message){
  ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          message
      ))
  );
}


class ImageTile extends StatelessWidget{
  int img_id;
  Image img;
  Widget Function(BuildContext context, Widget image) inner_wrapper;
  Widget Function(BuildContext context, Widget image) outter_wrapper;

  ImageTile(this.img, {Key? key, this.on_double_tap,
    this.inner_wrapper = default_inner_wrapper,
    this.outter_wrapper = default_outter_wrapper,
    this.img_id = -1,
  }) : super(key: key);
  Function()? on_double_tap;


  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding_blur = EdgeInsets.symmetric(horizontal: 10);
    const EdgeInsets padding_non_blur = EdgeInsets.symmetric(
      horizontal: 13,
      vertical: 3,
    );

    return default_outter_wrapper(context,
        GestureDetector(
        onDoubleTap: on_double_tap,

        child: ClipRect(
          child: inner_wrapper(context,
            Stack(
              children: [
                Positioned.fill(
                    child: FilteredImage(
                      img: img.image,
                      padding: padding_blur,
                    )
                ),
                Positioned.fill(child: Padding(
                  padding: padding_non_blur,
                  child: img,
                )),
              ],
            )
          ),
        ),
        ),
    );
  }

  static Widget default_inner_wrapper(BuildContext context, Widget image){
    return Center(
      child:SizedBox(
          height: 220,
          width: 220,
          child: image,
      ),
    );
  }

  static Widget default_outter_wrapper(BuildContext context, Widget image){
    return Container(
        margin: EdgeInsets.all(5),
        child: image
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

enum StatusVerifikasi{
  BELUM_MENGAJUKAN, SEDANG_MENGAJUKAN, DITOLAK, TERVERIFIKASI
}