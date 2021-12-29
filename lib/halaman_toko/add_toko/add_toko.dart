// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:bizzvest/halaman_toko/add_toko/toko_model.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko_edit_description.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';
import 'package:bizzvest/halaman_toko/shared/loading_screen.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(AddTokoMaterial());
}


const InputDecoration text_form_field_input_decoration = InputDecoration(
  labelText: 'Label text',
  errorMaxLines: 2,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  labelStyle: TextStyle(
    color: Color(0xFF0047D3),
  ),
  helperText: '',
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF28BCFF)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF28BCFF)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFF3939)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFF3939)),
  ),


  /*errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF28BCFF)),
  ),
  errorStyle: TextStyle(fontSize: 13, height: 2,),*/
  // contentPadding: EdgeInsets.only(left: 11, right: 3, top: 40, bottom: 14),



  // filled: true,
  // fillColor: Color.fromARGB(140, 255, 255, 255),
);


class AddTokoMaterial extends StatelessWidget{
  const AddTokoMaterial({Key? key}) : super(key: key);

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

      home: AddToko(),
    );
  }
}



class AddToko extends StatefulWidget{
  const AddToko({Key? key}) : super(key: key);

  @override
  State<AddToko> createState() => _AddTokoState();
}



class _AddTokoState extends State<AddToko> {
  static const int TIMEOUT_RETRY_LIMIT = 4;
  int timeout_retry_number = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        body: RequestLoadingScreenBuilder(
          request_function: () async {
            var auth = await get_authentication();
            return auth.get(
              uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_add_toko_API)
            );
          },

          wrapper: (widget, status) {
            return widget;
          },

          on_success: (BuildContext context, AsyncSnapshot<dynamic> snapshot,
                ReqResponse response, Function(Function()) refresh) {
            String raw_content = response.data_string!;
            Map<String, dynamic> map = json.decode(raw_content);

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10),
              child: AddTokoBody(
                initial_csrf: map['csrftoken'],
              ),
            );
          },
        ),
        backgroundColor: STYLE_CONST.background_color,

        floatingActionButton: null,
      ),
    );
  }
}






class AddTokoBody extends StatefulWidget{
  final String initial_csrf;
  GlobalKey<FormState> form_key = GlobalKey<FormState>();
  AddTokoBody({required this.initial_csrf, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTokoBody();

}

class _AddTokoBody extends State<AddTokoBody>{
  GlobalKey<FormState> get form_key{
    return widget.form_key;
  }

  late String initial_csrf;
  bool is_validate_only = true;
  CompanyForm form_data = CompanyForm();
  CompanyFormErrors form_errors = CompanyFormErrors();
  DateTime picked_date = DateTime.now().add(Duration(days:1));

  double margin_size=0;
  AutovalidateMode auto_validate=AutovalidateMode.disabled;
  var berakhir_date_txt = TextEditingController();
  bool enable_submit_button = true;

  String csrf_token = "";

  @override
  void initState() {
    super.initState();
    csrf_token = widget.initial_csrf;
  }

  @override
  Widget build(BuildContext context) {
    TextFormField berakhir_date;

    String? number_validator(value){
      if (value == null || value.isEmpty)
        return "This field is required";
      if (!isInteger(value))
        return "This field must be a postive integer";
      if (int.parse(value) <= 0)
        return "This field must be a postive integer";
    };

    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20,  horizontal: 0),
            child: BorderedContainer(
                Form(
                  key: form_key,
                  autovalidateMode: auto_validate,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Nama merek",
                        ),
                        validator: (value){
                          if (form_errors.nama_merek != null)
                            return form_errors.nama_merek;
                          if (value?.isEmpty ?? true)
                            return "This field is required";
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.nama_merek = value;
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Nama perusahaan",
                        ),
                        validator: (value){
                          if (form_errors.nama_perusahaan != null)
                            return form_errors.nama_perusahaan;
                          if (value?.isEmpty ?? true)
                            return "This field is required";
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.nama_perusahaan = value;
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Kode saham",
                        ),
                        validator: (value){
                          if (form_errors.kode_saham != null)
                            return form_errors.kode_saham;
                          if (value == null || value.isEmpty)
                            return "This field is required";
                          if (value.length != 4)
                            return "This field must consists of 4 letters";
                          if (!RegExp(r'^[A-Z]{4}$').hasMatch(value))
                            return "Must be upper case letters of 4 characters";
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4)
                        ],
                        onSaved: (String? value){
                          if (value != null)
                            form_data.kode_saham = value;
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Alamat perusahaan",
                        ),
                        validator: (value){
                          if (form_errors.alamat != null)
                            return form_errors.alamat;
                          if (value?.isEmpty ?? true)
                            return "This field is required";
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.alamat = value;
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Jumlah lembar saham",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if (form_errors.jumlah_lembar != null)
                            return form_errors.jumlah_lembar;
                          return number_validator(value);
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.jumlah_lembar = int.parse(value);
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Nilai lembar saham (rupiah)",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if (form_errors.nilai_lembar_saham != null)
                            return form_errors.nilai_lembar_saham;
                          return number_validator(value);
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.nilai_lembar_saham = int.parse(value);
                        },
                        
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Dividen (bulan)",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if (form_errors.dividen != null)
                            return form_errors.dividen;
                          return number_validator(value);
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.dividen = int.parse(value);
                        },
                      ),

                      SizedBox(height: margin_size,),
                      berakhir_date = TextFormField(
                        controller: berakhir_date_txt,
                        readOnly: true,
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Batas waktu",
                        ),
                        onTap: (){
                          showDatePicker(
                            context: context,
                            initialDate: picked_date,
                            firstDate: DateTime.now().add(Duration(days:1)),
                            lastDate: DateTime.now().add(Duration(days:360*15)),
                          ).then((value){
                            if (value == null) return;

                            String day = value.day.toString().padLeft(1, '0');
                            String month = value.month.toString().padLeft(1, '0');
                            String year = value.year.toString().padLeft(1, '0');
                            picked_date = value;
                            berakhir_date_txt.text = "$month/$day/$year";
                          });
                        },

                        validator: (value){
                          if (form_errors.end_date != null)
                            return form_errors.end_date;
                          if (value == null || value.isEmpty)
                            return "This field is required";
                        },

                        onSaved: (String? value){
                          if (value != null)
                            form_data.end_date = value;
                        },
                      ),

                      /*InputDatePickerFormField(
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days:360*15)),
                      ),*/

                      SizedBox(height: margin_size,),
                      TextFormField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        enabled: true,
                        textAlign: TextAlign.justify,
                        minLines: 4,
                        maxLines: 8,
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Deskripsi",
                        ),
                        validator: (value){
                          if (form_errors.deskripsi != null)
                            return form_errors.deskripsi;
                          if (value == null || value.isEmpty)
                            return "This field is required";
                        },
                        onSaved: (String? value){
                          if (value != null)
                            form_data.deskripsi = value;
                        },
                      ),

                      SizedBox(height: margin_size,),
                      ElevatedButton(
                        child: Text("Submit"),
                        onPressed: on_submit(context),
                      ),

                    ],
                  ),
                )
            ),
          ),
        ],
      );
  }

  Function()? on_submit(BuildContext context){
    if (!enable_submit_button)
      return null;

    return () async {
      form_errors = CompanyFormErrors();
      if (form_key.currentState != null
          && form_key.currentState!.validate()){
        setState(() {
          margin_size = 0;
          auto_validate = AutovalidateMode.disabled;
        });

        show_snackbar(context, "Sending to server");
        form_key.currentState?.save();
        is_validate_only = true;
        await validate_form_to_server(context);

      }else{
        setState(() {
          margin_size = 30;
          auto_validate = AutovalidateMode.onUserInteraction;
        });
        show_snackbar(context, "Invalid input");
      }
    };
  }

  Future<void> validate_form_to_server(BuildContext context) async {
    setState(() {
      enable_submit_button = false;
    });
    show_snackbar(context, "Validating current form to server");

    var auth = await get_authentication();
    ReqResponse response;
    var dict = form_data.to_map()
      ..addAll({
        COOKIE_CONST.csrf_token_formdata: csrf_token,
        'is_validate_only': 1,
        'my_data': json.encode([1, 2, 3]),
      });

    try {

      print(dict);
      response = await auth.post(
        uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_add_toko_API),
        data: dict,
      );
    } on DioError catch(e){
      if (Session.is_timeout_error(e)){
        show_snackbar(context, "Request timed out");
        return;
      }
      throw e;
    }finally{
      setState(() {
        enable_submit_button = true;
      });
    }


    Map<String, dynamic> map;
    if (!response.has_problem || response.statusCode == 422){
      map = json.decode(response.data_string!);
      if (map['csrftoken'] != null)
        csrf_token = map['csrftoken']!;

      if (response.statusCode == 422){
        Map<String, String> map_of_error = {};
        Map temp = map['errors'];
        temp.forEach((key, value) {
          map_of_error[key] = value.last;
        });

        setState(() {
          margin_size = 30;
          auto_validate = AutovalidateMode.onUserInteraction;
          form_errors = CompanyFormErrors.from_map(map_of_error);
          form_key.currentState?.validate();
        });
        show_snackbar(context, "Invalid form data");
        return;
      }
    }



    if (response.has_problem){
      show_snackbar(context, "Error ${response.statusCode} ${response.reasonPhrase}");
      return;
    }


    SimplePrompt(
      const Text("Registration confirmation"),
      const Text(
          "Apakah Anda benar-benar ingin mengirim data?"
          + "\n\n"
          + "Setelah Anda mengirim data, Anda tidak akan dapat menghapus "
          + "maupun mengubah beberapa data yang telah Anda submit. "),
      [
        SimplePromptAction("Cancel", (){
          Navigator.pop(context);
        }),
        SimplePromptAction("Tetap submit", () async {
          Navigator.pop(context);
          await submit_form_to_server(context);
        }),
      ]
    ).show(context);
  }

  Future<void> submit_form_to_server(BuildContext context) async {
    setState(() {
      enable_submit_button = false;
    });

    show_snackbar(context, "Submitting current form to server");

    var auth = await get_authentication();
    ReqResponse? response;
    try {
      for (var i=3; i >= 1; i--){
        try {
          response = await auth.post(
            uri: NETW_CONST.get_server_URI(NETW_CONST.halaman_toko_add_toko_API),
            data: form_data.to_map()
              ..addAll({
                COOKIE_CONST.csrf_token_formdata: csrf_token,
                'is_validate_only': 0,
              }),
          );
          break;
        } on DioError catch(e){
          if (Session.is_timeout_error(e)){
            String temp = "";
            if (i > 1)
              temp = "Retrying...";
            show_snackbar(context, "Request timed out. " + temp);
          }
          if (i == 1)
            throw e;
        }
      }

    }finally{
      setState(() {
        enable_submit_button = true;
      });
    }

    if (response == null){
      ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Internal error: null response")));
      return;
    }
    if (response.has_problem){
      ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Errpor ${response.statusCode} ${response.reasonPhrase}")));
      return;
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully submitted to server")));
    setState(() {
      enable_submit_button = true;
    });

    Map<String, dynamic> map = json.decode(
        response.data_string!
    );
    int id = map['id'];

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => HalamanToko(id: id)));
  }
}



bool isInteger(String s) {
  if(s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}
