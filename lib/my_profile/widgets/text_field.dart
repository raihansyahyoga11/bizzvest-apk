import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import '../screens/EditingPage.dart';
import '../screens/ProfilePage.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  // final ValueChanged<dynamic> onChanged;
  final String dropdownvalue = 'Pilih jenis kelamin';
  var items =  ['Laki-laki','Perempuan'];

  TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    this.label="",
    this.text="",
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[600]),
            
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (value) {
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: widget.maxLines,
            
          ),
        ],
      );
}