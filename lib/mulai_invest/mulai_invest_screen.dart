import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:provider/provider.dart';
// import 'package:bizzvest/halaman_toko/shared/configurations.dart';
// import 'package:bizzvest/halaman_toko/shared/utility.dart';
// import 'package:bizzvest/login_signup/cookie.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bar_chart.dart';
import 'line_chart.dart';


class MulaiInvestScreen extends StatefulWidget {
  static const routeName = '/mulai-invest';
  MulaiInvestScreen();

  @override
  _MulaiInvestScreenState createState() => _MulaiInvestScreenState();
}

class _MulaiInvestScreenState extends State<MulaiInvestScreen> {
  final converter = new NumberFormat("#,##0.00", "ID");
  Future<Map<String, dynamic>>? investStuff;

  String result = '';
  Color warnaSaham = Colors.black;
  String result2 = '';
  String saldoMessage = '';
  bool _msgVisible = false;
  bool _saldoLoadVisible = false;
  bool _sahamLoadVisible = false;
  bool _sahamMsgVisible = false;

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();  
  final _formKey2 = GlobalKey<FormState>(); 

  int? companyId = 0;
  int? userId = 0;
  String userSaldo = '';
  List<String> imgList = [];
  int sahamTerjual = 0;
  int sahamTersisa = 0;
  int sahamDimiliki = 0; // Dimiliki pengakses

  void initState () {
    super.initState();
    _msgVisible = false;
    _saldoLoadVisible = false;
    _sahamLoadVisible = false;
    _sahamMsgVisible = false;
  }

  Future<Map<String, dynamic>> getSaldo(int? userId) async{
    final response = await http.get(
      Uri.parse('http://bizzvest-bizzvest.herokuapp.com/mulai-invest/flutter/get-saldo?userId=${userId}'),
        // body: {
        //   'userId': userId.toString(),
        // }
      );
    final decoded = json.decode(response.body);
    return decoded;
  }

  Future<void> setSaldo(int? userId) async{
    final response = await http.get(
      Uri.parse('http://bizzvest-bizzvest.herokuapp.com/mulai-invest/flutter/get-saldo?userId=${userId}'),
        // body: {
        //   'userId': userId.toString(),
        // }
      );
    final decoded = json.decode(response.body);
    setState(() {
      userSaldo = ('Rp'+converter.format(decoded['saldo']));
      _saldoLoadVisible = false;
    });
  }

  // Gatau kenapa gabisa pake post :", argumennya ga sampe ke django
  Future<Map<String, dynamic>> getInvestStuff(int companyId) async{
    String apiUrl = 'http://bizzvest-bizzvest.herokuapp.com/mulai-invest/flutter/invest?id=' + companyId.toString();
    var url = Uri.parse(apiUrl);
    var apiResult = await http.get(
      Uri.parse('http://bizzvest-bizzvest.herokuapp.com/mulai-invest/flutter/invest?id=' + companyId.toString() + '&userId=${userId}')
      // headers: <String, String>{
      //   "Content-Type": "application/json",
      //   "Accept": "application/json",
      // },
      // body: 
      // jsonEncode(<String, String>{
      //   'userId': userId.toString(),
      // }),
    );
    // var apiResult = await http.post(
    //   url, 
    //   headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8'
    //   },
    //   body: jsonEncode(<String, String>{
    //       'userId': userId.toString(),
    //       // 'email': email,
    //       // 'message': message,
    //   }),
    //   // body: {'userId': userId},
    //   );
    Map<String, dynamic> extractedData = jsonDecode(apiResult.body);
    return extractedData;
  }

  Future<void> setSahamStuff(Map<String, dynamic>? sahamStuff) async {
    Map<String, dynamic>? sahamMap = sahamStuff;
    setState(() {
      sahamTerjual = sahamMap!['saham_terjual'];
      sahamTersisa = sahamMap['saham_tersisa'];
      sahamDimiliki = sahamMap['lembar_dimiliki'];
      _sahamLoadVisible = false;
    });
  }

  bool isInteger(String value) {
    return int.tryParse(value) != null;
  }

  bool isPositive(String value){
    int temp = int.parse(value);
    if(temp > 0){
      return true;
    }
    return false;
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25, 
          fontFamily: 'Tisa Sans Pro', 
          fontWeight: FontWeight.bold,
          
          ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null){
      companyId = 0;
    } else {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
      companyId = args['companyId'];
      userId = args['userId'];
    }
    
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: getInvestStuff(companyId!),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData){
              dynamic decodedData = (jsonDecode(snapshot.data['company']));
              var compNamaMerek = (decodedData[0]['fields']['nama_merek']);
              return 
                Text(compNamaMerek);
            } else {
                return CircularProgressIndicator();
            }
          }
        ),
        
        // backgroundColor: Color.fromRGBO(205, 245, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(205, 245, 255, 1),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            color: Color.fromRGBO(205, 245, 255, 1),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: getInvestStuff(companyId!),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData){
                      dynamic decodedData = (jsonDecode(snapshot.data['company']));
                      var compNamaMerek = (decodedData[0]['fields']['nama_merek']);
                      var compName = (decodedData[0]['fields']['nama_perusahaan']);
                      imgList = [];
                      for (String item in snapshot.data['company_photos']) {
                        imgList.add('http://bizzvest-bizzvest.herokuapp.com' + item);
                      }
                      return 
                      Column(children: <Widget>[
                        Text(
                          compNamaMerek,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/10,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(2, 117, 216, 1)
                          ),
                        ),
                        Text(
                          compName,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/15,
                            color: Color.fromRGBO(156, 160, 166, 1)
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: (imgList.length > 1),
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 1,
                                aspectRatio: 1/1,
                              ),
                              items: imgList.map(
                                (item) => Container(
                                  child: Center(
                                    child: Image.network(
                                      item, 
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                )
                              ).toList(),
                            )
                          ),
                        ),
                      ]
                    );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
                ),
                Container(
                  height: 350,
                  child: BarChart(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  height: 300,
                  child: LineChart(),
                ),
                buildSectionTitle(context, 'Informasi Saham'),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color.fromRGBO(93, 223, 255, 1),
                    ),
                  child: FutureBuilder(
                    future: getInvestStuff(companyId!),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData){
                        dynamic decodedData = (jsonDecode(snapshot.data['company']));
                        sahamTerjual = (snapshot.data['saham_terjual']);
                        sahamTersisa = (snapshot.data['saham_tersisa']);
                        var hargaSaham = decodedData[0]['fields']['nilai_lembar_saham'];
                        return 
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(
                              "Jumlah saham terjual: " + sahamTerjual.toString() + " lembar\n" + 
                              "Jumlah saham tersisa: " + sahamTersisa.toString() + " lembar\n" +
                              "Harga saham: " + hargaSaham.toString(),
                              style: TextStyle(fontSize: 16, fontFamily: 'Tisa Sans Pro')),
                          );
                      } else {
                        return Center(child:CircularProgressIndicator());
                      }
                    }
                  ),
                ),
                buildSectionTitle(context, 'Deskripsi Perusahaan'),
                Container(
                  width: double.infinity,
                  // color: Colors.white,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                  child: FutureBuilder(
                    future: getInvestStuff(companyId!),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData){
                        dynamic decodedData = (jsonDecode(snapshot.data['company']));
                        var compDesc = decodedData[0]['fields']['deskripsi'];
                        return 
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(compDesc,
                              style: TextStyle(fontSize: 16, fontFamily: 'Tisa Sans Pro')
                            ),
                          );
                      } else {
                        return Center(child:CircularProgressIndicator());
                      }
                    }
                  ),
                ),
                buildSectionTitle(context, 'Investasi Anda'),
                // buildContainer(
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Color.fromRGBO(93, 223, 255, 1),
                  ),
                  child: FutureBuilder(
                    future: getInvestStuff(companyId!),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData){
                        sahamDimiliki = (snapshot.data['lembar_dimiliki']);
                        return 
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: 
                              Text('Jumlah lembar saham yang telah Anda tanamkan:\n' + sahamDimiliki.toString() + ' lembar',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20, fontFamily: 'Tisa Sans Pro')
                              )
                          );
                      } else {
                        return Center(child:CircularProgressIndicator());
                      }
                    }
                  ),
                  
                ),
                buildSectionTitle(context, 'Saldo'),
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  child: Column (
                    children: [
                      FutureBuilder(
                        future: getSaldo(userId),
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData){
                            var userSaldo = ('Rp'+converter.format(snapshot.data['saldo']));
                            return 
                              Text(
                                userSaldo,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tisa Sans Pro'
                                ),
                              );
                          } else {
                            return Center(child:CircularProgressIndicator());
                          }
                        }
                      ),
                      Visibility(
                        visible: _saldoLoadVisible,
                        child: CircularProgressIndicator()
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Tambah Saldo'),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    Form(  
                                      key: _formKey2,  
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child:Container(
                                        // width: 350,
                                          margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.0),
                                          color: Color.fromRGBO(255, 255, 255, 0.6),
                                          ),
                                          child: Column(  
                                            crossAxisAlignment: CrossAxisAlignment.start,  
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[  
                                              TextFormField(  
                                                keyboardType: TextInputType.number,
                                                controller: myController2,
                                                decoration: new InputDecoration(
                                                  hintText: "e.g. 20000",
                                                  labelText: "Jumlah Saldo yang ingin ditambahkan:",
                                                  prefixIcon: Icon(Icons.attach_money),
                                                  border: OutlineInputBorder(
                                                    borderRadius: new BorderRadius.circular(5.0)
                                                  ),
                                                ),
                                                validator: (value) {
                                                  Future<void> cekStatus() async{
                                                    Map<String, dynamic> hasilBeli = await beliSaldo(myController2.text.toString());
                                                    if(hasilBeli['status'].compareTo('fail') == 0){
                                                      setState(() {
                                                        saldoMessage = 'Total saldo Anda tidak boleh melebihi 2 miliar rupiah';
                                                        _msgVisible = true;
                                                      });
                                                    } else{
                                                      saldoMessage = '';
                                                      _msgVisible = false;
                                                    }
                                                  }
                                                  if (value!.isEmpty) {
                                                    return 'Input tidak boleh kosong';
                                                  } else if (!isInteger(value)){
                                                    return 'Input harus berupa bilangan bulat';
                                                  } else if (!isPositive(value)){
                                                    return 'Input harus berupa bilangan positif';
                                                  } else{
                                                      cekStatus();
                                                  }
                                                  return null;
                                                },
                                                onFieldSubmitted: (value) {
                                                  if (_formKey2.currentState!.validate()) {
                                                    _saldoLoadVisible = true;
                                                    Future<void> updateSaldo() async{
                                                      // await beliSaldo(myController2.text.toString());
                                                      setSaldo(userId);
                                                      myController2.clear();
                                                    }
                                                    setState(() {
                                                      updateSaldo();
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                }, 
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'Max total saldo adalah 2 miliar Rupiah\n\nInput yang menyebabkan jumlah saldo di atas 2 miliar Rupiah akan mengakibatkan saldo Anda tidak bertambah',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Center(
                                                    // padding: const EdgeInsets.all(25.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (_formKey2.currentState!.validate()) {
                                                          _saldoLoadVisible = true;
                                                          Future<void> updateSaldo() async{
                                                            // await beliSaldo(myController2.text.toString());
                                                            setSaldo(userId);
                                                            myController2.clear();
                                                          }
                                                          setState(() {
                                                            updateSaldo();
                                                            Navigator.pop(context);
                                                          });
                                                        }
                                                      },
                                                      child: Text('Tambah'),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize: Size(200, 40),
                                                        primary: Colors.blue,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8), // <-- Radius
                                                        ),
                                                      ),
                                                    )
                                                  ),
                                                ]
                                              ),  
                                            ]
                                          )
                                        )
                                      ),  
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: _msgVisible,
                        child: SizedBox(
                          height: 20
                        ),
                      ),
                      Visibility(
                        visible: _msgVisible,
                        child: Text(saldoMessage)
                      )
                    ]
                  ),
                ),
                SizedBox(height: 20,),
                buildSectionTitle(context, 'Ayo Investasi!'),
                Form(  
                  key: _formKey,  
                  child: Container(
                    // width: 350,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    ),
                    child: Column(  
                      crossAxisAlignment: CrossAxisAlignment.start,  
                      children: <Widget>[  
                        SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.only(right: 5, left: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: "e.g. 20",
                              labelText: "Jumlah lembar saham yang ingin ditanamkan:",
                              prefixIcon: Icon(Icons.payments),
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0)
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Input tidak boleh kosong';
                              } else if (!isInteger(value)){
                                return 'Input harus berupa bilangan bulat';
                              } else if (!isPositive(value)){
                                return 'Input harus berupa bilangan positif';
                              } 
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                _sahamLoadVisible = true;
                                Future<void> updateSaldo1(String total) async{
                                  Map<String, dynamic> beli_saham = await beliSaham(companyId!.toString(), total);
                                  if (beli_saham['status'].compareTo('fail') == 0){
                                    setState(() {
                                      result = beli_saham['message'];
                                      warnaSaham = Colors.red;
                                      _sahamLoadVisible = false;
                                      _sahamMsgVisible = true;
                                    });
                                    return;
                                  }
                                  await setSaldo(userId);
                                  await setSahamStuff(await getInvestStuff(companyId!));
                                  setState(() {
                                    _sahamMsgVisible = true;
                                    result='Anda berhasil membeli '+ total + ' lembar saham';
                                    warnaSaham = Colors.black;
                                    _sahamLoadVisible = false;
                                  });
                                }
                                setState(() {
                                  updateSaldo1(myController.text.toString());
                                  myController.clear();
                                });
                              } else{
                                setState(() {
                                  _sahamMsgVisible = false;
                                  result='';
                                });
                              }
                            },  
                          ),
                        ),
                        SizedBox(height: 10,),
                        Visibility(
                          visible: _sahamMsgVisible,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child : Text(result, style: TextStyle(fontSize: 14, color: warnaSaham,))
                          )
                        ),
                        Center(
                        child: Visibility(
                            visible: _sahamLoadVisible,
                            child: CircularProgressIndicator()
                          ),
                        ),
                        Row( 
                          children: <Widget>[
                            SizedBox(width: 5,),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _sahamLoadVisible = true;
                                    Future<void> updateSaldo1(String total) async{
                                      Map<String, dynamic> beli_saham = await beliSaham(companyId!.toString(), total);
                                      if (beli_saham['status'].compareTo('fail') == 0){
                                        setState(() {
                                          result = beli_saham['message'];
                                          warnaSaham = Colors.red;
                                          _sahamLoadVisible = false;
                                          _sahamMsgVisible = true;
                                        });
                                        return;
                                      }
                                      await setSaldo(userId);
                                      await setSahamStuff(await getInvestStuff(companyId!));
                                      setState(() {
                                        _sahamMsgVisible = true;
                                        result='Anda berhasil membeli '+ total + ' lembar saham';
                                        warnaSaham = Colors.black;
                                        _sahamLoadVisible = false;
                                      });
                                    }
                                    setState(() {
                                      updateSaldo1(myController.text.toString());
                                      myController.clear();
                                    });
                                  } else{
                                    setState(() {
                                      _sahamMsgVisible = false;
                                      result='';
                                    });
                                  }
                                },
                                child: Text('Beli'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // <-- Radius
                                  ),
                                ),
                              )
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Batal'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            ),
                            SizedBox(width: 5,),
                          ]
                        ), 
                        SizedBox(height: 5,) 
                      ]
                    )
                  )
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> beliSaldo(String saldo) async {
    String apiURL = "http://bizzvest-bizzvest.herokuapp.com/mulai-invest/flutter/update-saldo?userId=${userId}&saldo=${saldo}";
    var url = Uri.parse(apiURL);
    var apiResult = await http.get(
      url,
      // body: {
      //   'userId': userId.toString(),
      //   'saldo': saldo
      // }
    );
    return jsonDecode(apiResult.body);
  }

  Future<Map<String, dynamic>> beliSaham(String companyId, String jumlahLembarSaham) async {
    String apiURL = "http://bizzvest-bizzvest.herokuapp.com/mulai-invest/flutter/beli-saham?userId=${userId}&companyId=${companyId}&jumlahLembarSaham=${jumlahLembarSaham}";
    var url = Uri.parse(apiURL);

    var apiResult = await http.get(
      url,
      // body: {
      //   'userId': userId.toString(),
      //   'companyId': companyId,
      //   'jumlahLembarSaham': jumlahLembarSaham,
      // }
    );
    return jsonDecode(apiResult.body);
  }
}
