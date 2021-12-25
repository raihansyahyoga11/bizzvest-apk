

import 'package:flutter/cupertino.dart';

void main() async {
  runApp(HalamanTokoEditDeskripsi(initial_description: "Halo dunia",));
}


class HalamanTokoEditDeskripsi extends StatefulWidget{
  final String initial_description;
  HalamanTokoEditDeskripsi({Key? key, required this.initial_description}) : super(key: key);


  @override
  State<HalamanTokoEditDeskripsi> createState() => _HalamanTokoEditDeskripsiState(description: initial_description);
}

class _HalamanTokoEditDeskripsiState extends State<HalamanTokoEditDeskripsi> {
  String description;
  _HalamanTokoEditDeskripsiState({required this.description});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, description);
        return false;
      },
      child: Text("Hello"),
    );
  }
}
