import 'package:bizzvest/halaman_toko/add_toko.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(HalamanTokoEditDeskripsi(initial_description: "Halo dunia"));
}


class HalamanTokoEditDeskripsiMaterialApp extends StatelessWidget{
  final String initial_description;
  final String? current_description;

  const HalamanTokoEditDeskripsiMaterialApp({Key? key,
    required this.initial_description,
    this.current_description,
  }) : super(key: key);

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
    home: HalamanTokoEditDeskripsi(
      initial_description: initial_description,
      current_description: current_description,
    ),
    );
  }
}


class HalamanTokoEditDeskripsi extends StatelessWidget{
  late GlobalKey<ScaffoldState> scaffold_key;
  final String initial_description;
  final String? current_description;

  HalamanTokoEditDeskripsi({Key? key,
    required this.initial_description,
    GlobalKey<ScaffoldState>? scaffold_key,
    this.current_description,
  }) : super(key: key){

    scaffold_key ??= GlobalKey<ScaffoldState>();
    this.scaffold_key = scaffold_key;
  }

  @override
  Widget build(BuildContext context) {
    print("HalamanTokoEditDeskripsi");
    return SafeArea(
          child: Scaffold(
            key: scaffold_key,
            backgroundColor: (Colors.lightBlue[200])!,
            floatingActionButton: null,
            body: _HalamanTokoEditDeskripsiBody(
              initial_description: initial_description,
              current_description: current_description,
            ),
          ),
        );
  }

}


class _HalamanTokoEditDeskripsiBody extends StatefulWidget{
  final description_textfield_controller = TextEditingController();
  final GlobalKey<FormState> form_key = GlobalKey<FormState>();
  final String initial_description;
  final String? current_description;

  _HalamanTokoEditDeskripsiBody({Key? key, 
    required this.initial_description,
    this.current_description,
  }) : super(key: key){


    description_textfield_controller.text = initial_description;

    if (current_description != null)
      description_textfield_controller.text = current_description!;
  }

  @override
  State<_HalamanTokoEditDeskripsiBody> createState() => _HalamanTokoEditDeskripsiBodyState(
  );
}


class _HalamanTokoEditDeskripsiBodyState extends State<_HalamanTokoEditDeskripsiBody> {
  get description_textfield_controller{
    return widget.description_textfield_controller;
  }
  get form_key{
    return widget.form_key;
  }

  double margin_size = 0;
  AutovalidateMode auto_validate = AutovalidateMode.disabled;


  @override
  Widget build(BuildContext context) {
    print("_HalamanTokoEditDeskripsiBodyState");
    return WillPopScope(
      onWillPop: () async {

        SimplePrompt(
          const Text("Save"),
          const Text("You are going to leave this page without saving the changes you have made."),
          [
            SimplePromptAction("Cancel", () {
              Navigator.pop(context); // dismis dialog
            }),
            SimplePromptAction("Discard", () {
              Navigator.pop(context);
              Navigator.pop(context, null);
            }),
            SimplePromptAction("Save", () {
              Navigator.pop(context);
              Navigator.pop(context, description_textfield_controller.text);
            }),
          ]
        ).show(context);

        return false;
      },

      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20,  horizontal: 0),
              child: BorderedContainer(
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal:10),
                    child: Form(
                      key: form_key,
                      autovalidateMode: auto_validate,
                      child: Column(
                        children: [
                          SizedBox(height: margin_size,),
                          TextFormField(
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            enabled: true,
                            textAlign: TextAlign.justify,
                            minLines: 3,
                            maxLines: 8,
                            controller: description_textfield_controller,
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
                            child: Text("Save"),
                            onPressed: (){
                              if (form_key.currentState != null
                                  && form_key.currentState!.validate()){
                                setState(() {
                                  margin_size = 0;
                                  auto_validate = AutovalidateMode.disabled;
                                });

                                Navigator.pop(context,
                                    description_textfield_controller.text);
                              }else{
                                setState(() {
                                  margin_size = 30;
                                  auto_validate = AutovalidateMode.onUserInteraction;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class SimplePromptAction{
  String text;
  Function() callback;

  SimplePromptAction(this.text, this.callback);
}

class SimplePrompt <T>{
  Widget title;
  Widget content;
  List<SimplePromptAction> actions;

  SimplePrompt(
    this.title,
    this.content,
    this.actions,
  );

  Future<void> show(BuildContext context) async {
    List<Widget> textbuttons = [];
    actions.forEach((element) {
      textbuttons.add(
        TextButton(
            onPressed: element.callback,
            child: Text(element.text),
        )
      );
    });

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: textbuttons,
          );
        }
    );
  }

}