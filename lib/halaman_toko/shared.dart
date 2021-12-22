import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'manage_photo.dart';
import 'configurations.dart';



Authentication authenticated_user = Authentication();
Future<Authentication> get_authentication() async{
  if (!authenticated_user.is_logged_in){
    await authenticated_user.login("hzzz", "1122");
  }
  return authenticated_user;
}


bool is_bad_status_code(int status_code){
  return status_code < 200 || status_code >= 400;
}

bool is_bad_response(Response response){
  return is_bad_status_code(response.statusCode);
}


class ImageTile extends StatelessWidget{
  Image img;
  Widget Function(BuildContext context, Widget image) inner_wrapper;
  Widget Function(BuildContext context, Widget image) outter_wrapper;

  ImageTile(this.img, {Key? key, this.on_double_tap,
    this.inner_wrapper = default_inner_wrapper,
    this.outter_wrapper = default_outter_wrapper,
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
