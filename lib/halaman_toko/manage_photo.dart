// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bizzvest/halaman_toko/configurations.dart';
import "package:bizzvest/halaman_toko/halaman_toko.dart";
import 'package:bizzvest/halaman_toko/shared.dart';


void main() {
  runApp(ManagePhotoMaterial());
}



class ManagePhotoMaterial extends StatelessWidget{
  const ManagePhotoMaterial({Key? key}) : super(key: key);


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

      home: ManagePhotoBody("Bizzvest", "PT. Bizzvest Indonesia"),
    );
  }
}



class ManagePhotoBody extends StatefulWidget{
  final String nama_merek;
  final String nama_perusahaan;
  ManagePhotoBody(this.nama_merek, this.nama_perusahaan, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManagePhotoBody(nama_merek, nama_perusahaan);
  }


}

class _ManagePhotoBody extends State<ManagePhotoBody>{
  final String nama_merek;
  final String nama_perusahaan;
  final GlobalKey<ScaffoldState> _scaffold_key = GlobalKey<ScaffoldState>();
  _ManagePhotoBody(this.nama_merek, this.nama_perusahaan);

  final ImagePicker _picker = ImagePicker();

  List<Widget> photo_items = [];

  Authentication authentication = Authentication();

  fetch_photo_from_server(BuildContext context, [int id=1]) async {
    var res = await authentication.get(
      uri: CONSTANTS.get_server_URI(
        CONSTANTS.halaman_toko_get_toko_json_path,
        {
          'id': id.toString()
        }
      )
    );

    print("fetch");
    print(res.request?.url);
    print(res.body);
    if (res.statusCode == 200){
      var result = json.decode(res.body) as List<dynamic>;
      print("fetch success");
      photo_items.clear();

      result.forEach((value) {
        if (value is Map<String, dynamic>){
          var map = value as Map<String, dynamic>;
          print("${map['url']}) added");

          int index = photo_items.length;
          photo_items.add(
                ImageTile(Image.network("http://" + CONSTANTS.server + map['url']),
                key: UniqueKey(),

                on_double_tap: (){
                  on_delete(index);
                },)
          );
        }
      });

      setState(() {});
    }
  }
  
  
  void initState() {
    super.initState();
    
    // ibarat onLoad()
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scaffold_key == null || _scaffold_key.currentContext == null)
        return;

      
      // login
      () async {
        print("logging in");
        http.Response resp = await authentication.login("hzzz", "1122");
        if (resp.statusCode != 200 && resp.statusCode != 302){
            print("login error: " + resp.statusCode.toString());
            print(resp.body);

            ScaffoldMessenger.of(_scaffold_key.currentContext!).showSnackBar(
              SnackBar(content: Text(
                "login error: " + resp.statusCode.toString()
                    + "\n ${resp.toString()}"
              ))
            );
            return;
        }

        print("login success");
        fetch_photo_from_server(context);
      }();



      ScaffoldMessenger.of(_scaffold_key.currentContext!).showSnackBar(
          const SnackBar(content: Text(
              "Please long press and hold to reorder the images \n"
              + "Double tap to delete photos"
          ))
      );


      }
    );
  }

  void on_delete(int index){
    setState(() {
      photo_items.removeAt(index);
    });
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
              setState(() {
                images?.forEach((element) {
                  int this_index = photo_items.length;

                  photo_items.add(
                    ImageTile(
                      Image.file(
                          File(element.path)
                      ),
                      key: UniqueKey(),
                      on_double_tap: (){
                        on_delete(this_index);
                      },
                    )
                  );
                });
              });
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