class Toko {
  int id;
  String namaPerusahaan;
  String namaToko;
  String img;

  Toko(
    {
      required this.id,
      required this.namaPerusahaan, 
      required this.namaToko, 
      required this.img
    }
  );

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
        id: json['id'],
        namaToko: json['nama_toko'],
        namaPerusahaan: json['nama_perusahaan'],
        img: json['img'],
    );
  }
}
