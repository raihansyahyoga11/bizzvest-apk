
class UserForm{
  String csrf_token;
  String nama_lengkap;
  int nomor_telepon ;
  String jenis_kelamin;
  String user_name;
  String e_mail;
  String deskripsi_saya;
  String status_verifikasi;
  String alamat_saya;
  String photo_profile; 


UserForm({
  this.csrf_token="",
  this.nama_lengkap="",
  this.nomor_telepon=0,
  this.jenis_kelamin="",
  this.user_name="",
  this.e_mail="",
  this.deskripsi_saya="",
  this.status_verifikasi="",
  this.alamat_saya="",
  this.photo_profile="" 
});


Map<String,dynamic> to_map() {
  return {
    'csrf_token': this.csrf_token,
    'nama_lengkap': this.nama_lengkap,
    'phone_number': this.nomor_telepon,
    'jenis_kelamin': this.jenis_kelamin,
    'username': this.user_name,
    'email': this.e_mail,
    'deskripsi_diri': this.deskripsi_saya,
    'status_verifikasi': this.status_verifikasi,
    'alamat': this.alamat_saya,
    'photo_profile': this.photo_profile
  };
}
}