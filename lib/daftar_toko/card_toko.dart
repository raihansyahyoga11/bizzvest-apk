import 'package:flutter/material.dart';


// processed from https://stackoverflow.com/questions/49819221/flutter-cards-how-to-loop-a-card-widgets-in-flutter
class CustomCard extends StatelessWidget {
  String nama_toko="";
  String nama_perusahaan="";
  String photo_id="";
  CustomCard(String nama_toko, String nama_perusahaan, int photo_id){
    this.nama_toko = nama_toko;
    this.nama_perusahaan = nama_perusahaan;
    this.photo_id = photo_id.toString();
  }
  @override
  Widget build(BuildContext context) {
              return new Card(
                      child: InkWell(                        
                        child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Column(
                            children: <Widget>[
                              new Image.asset('/images/'+this.photo_id+'.jpg',width:300,height:300),
                              new Padding(
                               padding: new EdgeInsets.all(7.0),
                               child: new Text(this.nama_toko ,style: new TextStyle(fontSize: 18.0),
                              ),
                              ),
                              new Padding(
                               padding: new EdgeInsets.all(7.0),
                               child: new Text(this.nama_perusahaan ,style: new TextStyle(fontSize: 13.0),
                               ),
                             ),
                            ],
                          )
                        )
                      ],
                    ),                      
                        onTap: () {                          
                        print("tapped on card");
                        },                      
                      )
                      
                  );
  }
}