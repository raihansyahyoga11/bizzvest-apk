import 'package:bizzvest/faq/api/api_faq.dart';
import 'package:flutter/material.dart';
import 'models/question.dart';

late Future<List<Question>?> futureQuestion = fetchQuestion();


class FaqUtamaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frequently Ask Question')),
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return new StuffInTiles(listOfTiles[index]);
                        },
                        itemCount: listOfTiles.length,
                      ),
                      Center(
                          child: Padding(
                              padding: EdgeInsets.all(35.0),
                              child: Text(
                                "Pertanyaan dari Pengguna Lain",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xff374ABE),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          )
                      ),
                      FaqListScreen(),
                      FormScreen(),


                    ],
                  ),
                )
            )
        )
    );
  }
}

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;
  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => print("tap"),
          title: new Text(t.title, style: TextStyle(fontSize: 16.0)));

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      backgroundColor: Colors.white70,
      collapsedBackgroundColor: Colors.white70,
      collapsedTextColor: Color(0xff374ABE),
      title: new Text(t.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
      children: t.children.map(_buildTiles).toList(),
    );
  }
}

class MyTile {
  String title;
  List<MyTile> children;
  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listOfTiles = <MyTile>[
  new MyTile(
    'Bagaimana cara mendaftarkan usaha di BizzVest?',
    <MyTile>[
      new MyTile('1) Buat akun di BizzVest terlebih dahulu pada halaman sign up)'
          '\n 2) Masukkan data usaha yang anda miliki, seperti nama usaha, deskripsi usaha, jumlah dan nilai lembar saham, serta dividen dan batas waktu.'
          '\n 3) Anda dapat memasukkan foto-foto dan proposal usaha pada halaman toko agar nantinya dapat meyakinkan investor untuk berinvestasi.'
          '\n 4) Tunggu usaha Anda selesai diverifikasi oleh administrator BizzVest selama 3-5 hari kerja.'),
    ],
  ),

  new MyTile(
    'Bagaimana cara berinvestasi di BizzVest?',
    <MyTile>[
      new MyTile('1) Buat akun di BizzVest terlebih dahulu pada halaman sign up.'
          '\n 2) Pilih usaha yang ingin anda berikan investasi dengan melihat deskripsi dan proposal dari usaha tersebut.'
          '\n 3) Berikan investasi sesuai dengan nominal nilai lembar saham dan banyaknya lembar saham yang Anda inginkan.'
          '\n 4) Analisis laporan keuangan usaha sambil menantikan dividen yang akan anda terima pada batas waktu yang telah ditentukan.'),
    ],
  ),

  new MyTile(
    'Berapa lama hasil investasi atau dividen didapatkan?',
    <MyTile>[
      new MyTile('Hasil investasi pembagian keuntungan saham akan didapatkan sesuai dengan kesepakatan antara pelaku UMKM/petani dengan investor sejak awal.'),
    ],
  ),

  new MyTile(
    'Berapa lama menunggu investor memberikan modal?',
    <MyTile>[
      new MyTile('Tidak dapat dipastikan lamanya waktu untuk mendapatkan modal dari investor. BizzVest hanya menjadi perantara antara pelaku UMKM/petani dengan investor. Namun, pelaku UMKM/petani dapat memberikan video profil, proposal, atau penawaran keuntungan investasi yang menarik minat investor. Usaha tersebut diharapkan dapat memperbesar kemungkinan mendapatkan modal dari investor.'),
    ],
  ),

  new MyTile(
    'Kenapa harus bergabung dengan BizzVest?',
    <MyTile>[
      new MyTile('BizzVest hadir sebagai perantara bagi pelaku bisnis seperti pemilik UMKM (Usaha Mikro, Kecil, dan Menengah) dan petani untuk mendapatkan modal usaha dari para investor agar dapat melanjutkan bisnis mereka. Siapapun dapat bertindak sebagai penerima atau pemberi modal sesuai dengan ketentuan yang berlaku.'),
    ],
  ),

];


class FaqListScreen extends StatelessWidget {

  final List pertanyaan = [
    "Bagaimana membuat proposal yang baik?",
    "Bagaimana cara mendapatkan badges investor?",
    "Apakah Bizzvest dapat dipercaya?",
  ];

  final List penanya = [
    "Arianna Mawar",
    "Langitnya Nebula",
    "Arani Dhita",
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureQuestion,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Custom Masker Cart is Empty'),
          );
        } else if (snapshot.hasData) {
          return _listFAQ(snapshot.data as List<Question>);
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _listFAQ(List<Question> questions) {
    double field = 75;
    return Container(
      height: field * questions.length,
      child: ListView.builder(
            itemCount: questions.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var question = questions[index].fields;
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Text(question!.pertanyaan, textAlign: TextAlign.left, style: TextStyle(fontSize: 17, color: Color(0xff374ABE), fontWeight: FontWeight.bold)),
                        Text("Pertanyaan dari " + question.nama, textAlign: TextAlign.left, style: TextStyle(fontSize: 17, color: Color(0xff374ABE))),
                      ],
                    )
                ),
              );
            },
        ),
    );
  }

}



class FormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            Center(
                child: Padding(
                    padding: EdgeInsets.all(35.0),
                    child: Text(
                      "Ada Pertanyaan Lainnya?",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Color(0xff374ABE),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                )
            ),

            new Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 25.0, bottom: 5.0, start: 16.0, end: 16.0),
                child: Text(
                  "Nama:",
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff374ABE)),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: "Tuliskan nama Anda...",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  ],
                ),

              ),
            ),

            new Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 25.0, bottom: 5.0, start: 16.0, end: 16.0),
                child: Text(
                  "Pertanyaan:",
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff374ABE)),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      maxLines: 7,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: "Tuliskan pertanyaan Anda...",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  ],
                ),

              ),
            ),

            SizedBox(height: 20.0),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(10.0),
                color: Color(0xff374ABE),
                onPressed: () {
                  _navigateToNextScreen(context);
                },
                child: Text("Kirimkan pertanyaan", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    fontSize: 17.0
                ))
            )

          ],
        );
  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaqListScreen()));
  }
}
