

class CompanyForm{
  String nama_merek = "";
  String nama_perusahaan = "";
  String kode_saham = "";
  String alamat = "";
  int jumlah_lembar = 0;
  int nilai_lembar_saham = 0;
  int dividen = 0;
  String end_date = "";
  String deskripsi = "";

  CompanyForm({
    this.nama_merek="",
    this.nama_perusahaan="",
    this.kode_saham="",
    this.alamat="",
    this.jumlah_lembar=0,
    this.nilai_lembar_saham=0,
    this.dividen=0,
    this.end_date="",
    this.deskripsi="",
  });


  Map<String, dynamic> to_map(){
    return {
      'nama_merek': this.nama_merek,
      'nama_perusahaan': this.nama_perusahaan,
      'kode_saham': this.kode_saham,
      'alamat': this.alamat,
      'jumlah_lembar': this.jumlah_lembar,
      'nilai_lembar_saham': this.nilai_lembar_saham,
      'dividen': this.dividen,
      'end_date': this.end_date,
      'deskripsi': this.deskripsi,
    };
  }
}



class CompanyFormErrors{
  String? nama_merek = null;
  String? nama_perusahaan = null;
  String? kode_saham = null;
  String? alamat = null;
  String? jumlah_lembar = null;
  String? nilai_lembar_saham = null;
  String? dividen  = null;
  String? end_date = null;
  String? deskripsi = null;

  CompanyFormErrors({
    this.nama_merek,
    this.nama_perusahaan,
    this.kode_saham,
    this.alamat,
    this.jumlah_lembar,
    this.nilai_lembar_saham,
    this.dividen,
    this.end_date,
    this.deskripsi,
  });


  Map<String, String> to_map(){
    return {
      if (this.nama_merek != null)
        'nama_merek': this.nama_merek!,
      if (this.nama_perusahaan != null)
        'nama_perusahaan': this.nama_perusahaan!,
      if (this.kode_saham != null)
        'kode_saham': this.kode_saham!,
      if (this.alamat != null)
        'alamat': this.alamat!,
      if (this.jumlah_lembar != null)
        'jumlah_lembar': this.jumlah_lembar!,
      if (this.nilai_lembar_saham != null)
        'nilai_lembar_saham': this.nilai_lembar_saham!,
      if (this.dividen != null)
        'dividen': this.dividen!,
      if (this.end_date != null)
        'end_date': this.end_date!,
      if (this.deskripsi != null)
        'deskripsi': this.deskripsi!,
    };
  }


  static CompanyFormErrors from_map(Map<String, String> map){
    CompanyFormErrors ret = CompanyFormErrors();

    if (map.containsKey('nama_merek'))
      ret.nama_merek = map['nama_merek'];
    if (map.containsKey('nama_perusahaan'))
      ret.nama_perusahaan = map['nama_perusahaan'];
    if (map.containsKey('kode_saham'))
      ret.kode_saham = map['kode_saham'];
    if (map.containsKey('alamat'))
      ret.alamat = map['alamat'];
    if (map.containsKey('jumlah_lembar'))
      ret.jumlah_lembar = map['jumlah_lembar'];
    if (map.containsKey('nilai_lembar_saham'))
      ret.nilai_lembar_saham = map['nilai_lembar_saham'];
    if (map.containsKey('dividen'))
      ret.dividen = map['dividen'];
    if (map.containsKey('end_date'))
      ret.end_date = map['end_date'];
    if (map.containsKey('deskripsi'))
      ret.deskripsi = map['deskripsi'];

    return ret;
  }
}