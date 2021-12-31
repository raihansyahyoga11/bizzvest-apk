class User {

  final String? csrfToken;
  final String? namaLengkap;
  final String? nomorTelepon ;
  final String? jenisKelamin;
  final String? username;
  final String? email;
  final String? deskripsi;
  final bool investor;
  final bool enterpreneur;
  final String? alamat;
  final String? photoProfile;



  User(
    {
      required this.namaLengkap, 
      required this.nomorTelepon, 
      required this.jenisKelamin, 
      required this.username, 
      required this.email, 
      required this.deskripsi,
      required this.csrfToken,
      required this.alamat,
      required this.investor,
      required this.enterpreneur,
      required this.photoProfile
      }
      );

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      namaLengkap:  parsedJson['full_name'],
      nomorTelepon: parsedJson["phone_number"],
      jenisKelamin: parsedJson["gender"],
      username: parsedJson["username"],
      email: parsedJson["email"],
      deskripsi: parsedJson["deskripsi_diri"],
      csrfToken: parsedJson["csrf_token"],
      alamat: parsedJson["alamat"],
      enterpreneur: parsedJson["enterpreneur"] == 1,
      investor: parsedJson["investor"] == 1,
      photoProfile: parsedJson["photo_profile"]
    );
  }

}



