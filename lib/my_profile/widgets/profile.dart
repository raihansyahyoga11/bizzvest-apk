import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProfileWidget extends StatelessWidget {
  late String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  // Widget changePhoto(BuildContext context) {
  //     return RaisedButton(
  //     child: Text('UPLOAD FILE'),
  //     onPressed: () async {
  //       var picked = await FilePicker.platform.pickFiles();

  //       if (picked != null) {
  //         print(picked.files.first.name);
  //       }
  //     },
  //   );
  // }
  
  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked
                    // getImage().then((String value) {
                    //   // setState(() {
                    //     print(value);
                    //       //  });
                    //   onSaved: (value);
                    //       if (value != null) {
                    //       formUser.photo_profile = value;
                    //       }
                    //   });),
        )
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
  Future<String> getImage() async {
    final picked = await FilePicker.platform.pickFiles();
    if (picked != null) {
          print(picked.files.first.name);
          return picked.files.first.name;
    }
    else {
      return ("ahhahaa");
    }
  }

  // Future getImage() async {
  //   File _image;
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source:ImageSource.gallery);
  //   setState((){
  //     if (pickedFile != null) {
  //       _image = File(PickedFile.path);
  //     }
  //   })
  // }

 