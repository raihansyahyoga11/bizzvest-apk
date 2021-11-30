// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:lab_7/halaman_toko.dart";


void main() {
  runApp(AddTokoMaterial());
}


const InputDecoration text_form_field_input_decoration = InputDecoration(
  labelText: 'Label text',
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

      home: SafeArea(child: Scaffold(
        body:SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: AddTokoBody("Bizzvest", "PT. Bizzvest Indonesia"),
        ),
        backgroundColor: (Colors.lightBlue[200])!,

        floatingActionButton: null,
      ),
      ),
    );
  }
}



class AddTokoBody extends StatefulWidget{
  final String nama_merek;
  final String nama_perusahaan;
  const AddTokoBody(this.nama_merek, this.nama_perusahaan, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddTokoBody(nama_merek, nama_perusahaan);
  }

}

class _AddTokoBody extends State<AddTokoBody>{
  final String nama_merek;
  final String nama_perusahaan;
  _AddTokoBody(this.nama_merek, this.nama_perusahaan);

  final GlobalKey<FormState> form_key = GlobalKey<FormState>();
  DateTime picked_date = DateTime.now().add(Duration(days:1));

  double margin_size=0;
  AutovalidateMode auto_validate=AutovalidateMode.disabled;
  var berakhir_date_txt = TextEditingController();

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
                          if (value?.isEmpty ?? true)
                            return "This field is required";
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Nama perusahaan",
                        ),
                        validator: (value){
                          if (value?.isEmpty ?? true)
                            return "This field is required";
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Kode saham",
                        ),
                        validator: (value){
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
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Alamat perusahaan",
                        ),
                        validator: (value){
                          if (value?.isEmpty ?? true)
                            return "This field is required";
                        },
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Jumlah lembar saham",
                        ),
                        keyboardType: TextInputType.number,
                        validator: number_validator,
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Nilai lembar saham (rupiah)",
                        ),
                        keyboardType: TextInputType.number,
                        validator: number_validator,
                        
                      ),

                      SizedBox(height: margin_size,),
                      TextFormField(
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Dividen (bulan)",
                        ),
                        keyboardType: TextInputType.number,
                        validator: number_validator,
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
                          if (value == null || value.isEmpty)
                            return "This field is required";
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
                        maxLines: 20,
                        decoration: text_form_field_input_decoration.copyWith(
                          labelText: "Deskripsi",
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty)
                            return "This field is required";
                        },
                      ),

                      SizedBox(height: margin_size,),
                      ElevatedButton(
                        child: Text("Submit"),
                        onPressed: (){
                          if (form_key.currentState != null
                              && form_key.currentState!.validate()){
                            setState(() {
                              margin_size = 0;
                              auto_validate = AutovalidateMode.disabled;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Sending to server")));
                          }else{
                            setState(() {
                              margin_size = 30;
                              auto_validate = AutovalidateMode.onUserInteraction;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid input")));
                          }
                        },
                      ),

                    ],
                  ),
                )
            ),
          ),
        ],
      );
  }
}



bool isInteger(String s) {
  if(s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}
