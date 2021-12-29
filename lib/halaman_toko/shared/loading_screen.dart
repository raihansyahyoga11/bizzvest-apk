

import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'configurations.dart';

class RequestLoadingScreenBuilder extends StatefulWidget{
  final Future<ReqResponse> Function() request_function;
  final int TIMEOUT_RETRY_LIMIT;
  Widget Function(Widget widget, RequestStatus status) wrapper = (widget, status){
    return Scaffold(
        body: widget
    );
  };

  // Function(context, snapshot, response, refresh)
  final Widget Function(BuildContext context, AsyncSnapshot snapshot,
      ReqResponse response, Function(Function()) refresh) on_success;

  RequestLoadingScreenBuilder({
    required this.request_function,
    required this.on_success,
    this.TIMEOUT_RETRY_LIMIT=3,
    Widget Function(Widget widget, RequestStatus status)? wrapper,
    Key? key
  }) : super(key: key){

    if (wrapper != null)
      this.wrapper = wrapper;
  }


  @override
  State<RequestLoadingScreenBuilder> createState() => _RequestLoadingScreenBuilderState();

  static T? cast<T>(x) => x is T ? x : null;
}


enum RequestStatus{
  pending, timed_out, timed_out_final, exception, bad_status_code,
  null_response, success
}


class _RequestLoadingScreenBuilderState extends State<RequestLoadingScreenBuilder> {
  int timeout_retry_number = 0;


  void refresh([Function()? func]){
    setState(func ?? (){});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.request_function(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done){
            return widget.wrapper(
                Container(
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
                ), RequestStatus.pending
            );
          }

          ReqResponse? req_resp = RequestLoadingScreenBuilder.cast<ReqResponse>(snapshot.data);
          if (snapshot.hasError){
            if (Session.is_timeout_error(snapshot.error)){
              RequestStatus req_status = RequestStatus.timed_out_final;

              if (timeout_retry_number < widget.TIMEOUT_RETRY_LIMIT) {
                req_status = RequestStatus.timed_out;
                Future.delayed(Duration(seconds: 2+2*timeout_retry_number))
                    .then((value) => setState(() {timeout_retry_number += 1;}));
              }

              return widget.wrapper(
                  Container(
                    child: const Center(
                      child: Text(
                        "Request timed out",
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ), req_status
              );
            }

            Future.error(
                snapshot.error!,
                snapshot.stackTrace);

            return widget.wrapper(
                Scaffold(
                  body: Container(
                      child: const Center(
                        child: Text(
                          "An internal error has occurred. ",
                          textDirection: TextDirection.ltr,
                        ),
                      )
                  ),
                ), RequestStatus.exception
            );
          }

          if (req_resp == null) {
            return widget.wrapper(
                Container(
                  child: const Center(
                    child: Text(
                      "request response is null",
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ), RequestStatus.null_response
            );
          }

          if (req_resp.has_problem) {
            return widget.wrapper(
                Container(
                  child: Center(
                    child: Text(
                      "Error ${req_resp.statusCode} ${req_resp.reasonPhrase}",
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ), RequestStatus.bad_status_code
            );
          }

          return widget.wrapper(
              widget.on_success.call(context,snapshot,req_resp,setState), RequestStatus.success
          );
        },
    );
  }
}