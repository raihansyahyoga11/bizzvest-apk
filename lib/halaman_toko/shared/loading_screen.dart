

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'configurations.dart';

class RequestLoadingScreenBuilder extends StatefulWidget{
  final Future<ReqResponse> request;
  final int TIMEOUT_RETRY_LIMIT;

  // Function(context, snapshot, response, refresh)
  final Widget Function(BuildContext, AsyncSnapshot, ReqResponse, Function(Function())) on_success;

  RequestLoadingScreenBuilder({
    required this.request,
    required this.on_success,
    this.TIMEOUT_RETRY_LIMIT=3,
    Key? key}) : super(key: key);


  @override
  State<RequestLoadingScreenBuilder> createState() => _RequestLoadingScreenBuilderState();

  static T? cast<T>(x) => x is T ? x : null;
}

class _RequestLoadingScreenBuilderState extends State<RequestLoadingScreenBuilder> {
  int timeout_retry_number = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.request,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done){
            return Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Center(
                            child: CircularProgressIndicator()
                        ),
                        SizedBox(width:0, height:20),
                        Center(
                            child: Text(
                              "Fetching company information",
                              textDirection: TextDirection.ltr,)
                        ),
                      ]
                  ),
                ),
              ),
            );
          }

          ReqResponse? req_resp = RequestLoadingScreenBuilder.cast<ReqResponse>(snapshot.data);
          if (snapshot.hasError){
            if (Session.is_timeout_error(snapshot.error)){

              if (timeout_retry_number < widget.TIMEOUT_RETRY_LIMIT) {
                Future.delayed(Duration(seconds: 2+timeout_retry_number))
                    .then((value) => setState(() {timeout_retry_number += 1;}));
              }

              return Scaffold(
                body: Container(
                  child: const Center(
                    child: Text(
                      "Request timed out",
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              );
            }

            Future.error(
                snapshot.error!,
                snapshot.stackTrace);

            return Scaffold(
              body: Container(
                  child: const Center(
                    child: Text(
                      "An internal error has occurred. ",
                      textDirection: TextDirection.ltr,
                    ),
                  )
              ),
            );
          }

          if (req_resp == null) {
            return Container(
              child: const Center(
                child: Text(
                  "request response is null",
                  textDirection: TextDirection.ltr,
                ),
              ),
            );
          }

          if (req_resp.has_problem) {
            return Container(
              child: Center(
                child: Text(
                  "Error ${req_resp.statusCode} ${req_resp.reasonPhrase}",
                  textDirection: TextDirection.ltr,
                ),
              ),
            );
          }

          return widget.on_success.call(context,snapshot,req_resp,setState);
        },
    );
  }
}