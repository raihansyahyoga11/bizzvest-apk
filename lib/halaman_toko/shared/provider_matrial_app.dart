

import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:provider/provider.dart';
import 'package:bizzvest/login_signup/cookie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderMaterialApp extends StatelessWidget{
  final Widget widget;

  const ProviderMaterialApp(this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) {
          CookieRequest request = CookieRequest();
          return request;
        },

        child: MaterialApp(
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.3,
                fontSizeDelta: 2.0,
                fontFamily: 'Tisan'
            ),
          ),
          title: "Bizzvest",
          home: widget,
      ),
    );
  }
}