
import 'package:bizzvest/halaman_toko/shared/user_account.dart';
import 'package:bizzvest/halaman_toko/shared/utility.dart';
import 'package:flutter/widgets.dart';

class HalamanTokoProperties{
  final int id;
  final bool is_curr_client_the_owner;
  final String nama_merek;
  final String nama_perusahaan;
  final List<Image> images;

  final StatusVerifikasi status_verifikasi;
  final String tanggal_berakhir;
  final String kode_saham;
  final String sisa_waktu;
  final String periode_dividen;
  final String alamat;
  String deskripsi;
  String? proposal_server_path;

  final UserAccount owner;

  final int jumlah_lembar_saham;
  final int jumlah_lembar_saham_tersisa;
  final int nilai_lembar_saham;

  double get persen_saham_tersisa => 100*jumlah_lembar_saham_tersisa / jumlah_lembar_saham;
  int get total_nilai_saham_tersisa => jumlah_lembar_saham_tersisa * nilai_lembar_saham;

  double get persen_saham_terjual => 100*jumlah_lembar_saham_terjual / jumlah_lembar_saham;
  int get jumlah_lembar_saham_terjual => jumlah_lembar_saham - jumlah_lembar_saham_tersisa;
  int get total_nilai_saham_terjual => nilai_lembar_saham * jumlah_lembar_saham_terjual;


  HalamanTokoProperties({
    required this.id,
    required this.is_curr_client_the_owner,
    required this.nama_merek,
    required this.nama_perusahaan,
    required this.images,
    required this.status_verifikasi,
    required this.tanggal_berakhir,
    required this.alamat,
    required this.deskripsi,
    required this.proposal_server_path,
    required this.owner,

    required this.kode_saham,
    required this.sisa_waktu,
    required this.periode_dividen,

    required this.jumlah_lembar_saham,
    required this.nilai_lembar_saham,
    required this.jumlah_lembar_saham_tersisa,
  });



  @override
  bool operator ==(Object other) {
    if (other is! HalamanTokoProperties) {
      return false;
    }
    if (identityHashCode(this) == identityHashCode(other)) {
      return true;
    }
    HalamanTokoProperties o = other;
    return nama_merek == o.nama_merek
        && id == o.id
        && deskripsi == o.deskripsi
        && proposal_server_path == o.proposal_server_path
        && alamat == o.alamat
        && nama_perusahaan == o.nama_perusahaan
        && images == o.images
        && status_verifikasi == o.status_verifikasi
        && tanggal_berakhir == o.tanggal_berakhir
        && kode_saham == o.kode_saham
        && sisa_waktu == o.sisa_waktu
        && periode_dividen == o.periode_dividen
        && jumlah_lembar_saham == o.jumlah_lembar_saham
        && nilai_lembar_saham == o.nilai_lembar_saham
        && jumlah_lembar_saham_tersisa == o.jumlah_lembar_saham_tersisa
        && owner == o.owner
    ;
  }

  @override
  int get hashCode =>
      nama_merek.hashCode
      ^ id.hashCode
      ^ nama_perusahaan.hashCode
      ^ alamat.hashCode
      ^ deskripsi.hashCode
      ^ proposal_server_path.hashCode
      ^ images.hashCode
      ^ status_verifikasi.hashCode
      ^ tanggal_berakhir.hashCode
      ^ kode_saham.hashCode
      ^ sisa_waktu.hashCode
      ^ periode_dividen.hashCode
      ^ jumlah_lembar_saham.hashCode
      ^ nilai_lembar_saham.hashCode
      ^ jumlah_lembar_saham_tersisa.hashCode
      ^ owner.hashCode
  ;
}
