[![pipeline status](https://gitlab.com/immanuel01/bizzvest-apk/badges/main/pipeline.svg)](https://gitlab.com/immanuel01/bizzvest-apk/commits/main)

# BizzVest

“Let’s invest toward your business”


## Kelompok C02
**Nama Anggota:**

1. 2006483201	Raissa Tito Safaraz
1. 2006483031	Raihansyah Yoga Adhitama
1. 2006463004	Ivan Phanderson
1. 2006463162	Immanuel
1. 2006473610	Azzam Labib Hakim
1. 2006473932	Ahmad Ghozi Fidinillah
1. 2006463963	Nandhita Zefania Maharani


## Link APK:


## Latar Belakang BizzVest:
Pandemi Covid-19 sudah berlangsung cukup lama dan perekonomian Indonesia telah terpengaruh oleh permasalahan ini. Banyak masyarakat Indonesia yang juga terkena dampak dari pandemi Covid-19 dan mengalami masalah keuangan padahal mereka harus terus menyambung hidup mereka. Oleh karena itu, BizzVest hadir sebagai jalan keluar bagi pelaku bisnis seperti pemilik UMKM (Usaha Mikro, Kecil, dan Menengah) dan petani untuk mendapatkan modal usaha dari para investor agar dapat melanjutkan bisnis mereka. BizzVest akan menjadi _intermediaries_ untuk mempertemukan pelaku usaha dan investor dalam melakukan investasi melalui website BizzVest. Pelaku usaha harus memberikan proposal dan video profil dari bisnis yang mereka miliki untuk dapat menarik perhatian investor. Investor dapat mengakses daftar usaha yang terdaftar dari BizzVest dan memilih untuk berinvestasi. Setelah dilakukannya investasi, pelaku bisnis harus membuat laporan pemasukan dan pengeluaran dari usaha yang mendapatkan dana investasi tersebut, lalu melaporkannya dengan transparan dan detail agar terdapat kepercayaan antara investor dan pelaku usaha. Kemudian, akan dilakukan bagi hasil antara pelaku bisnis dan investor sesuai dengan keuntungan yang didapatkan dan kesepakatan sebelumnya. 


## Nama modul dan pembagiannya:
1. Home & About BizzVest (Ahmad Ghozi Fidinillah)
1. Profil Pengguna (Raihansyah Yoga Adhitama)
1. Frequently Ask Question (Nandhita Zefania Maharani)
1. Halaman Toko, mendaftar toko baru (Immanuel)
1. Mulai Invest (Ivan Phanderson)
1. Daftar-daftar Toko yang ada (Azzam Labib Hakim)
1. Login, logout, sign up dan navbar & footer (Raissa Tito Safaraz)


## Cerita Modul:

### 1) Modul Frequently Ask Question (Nandhita Zefania Maharani)
Modul Frequently Ask Question akan memberikan jawaban dari pertanyaan-pertanyaan terkait BizzVest. Modul ini akan diimplementasikan menjadi mobile app dari website yang telah dibuat dengan menggunakan framework Django. Pada website BizzVest yang telah di deploy di Heroku sebelumnya, modul faq ini terdiri dari 3 bagian, yaitu faq utama berupa pertanyaan umum yang resmi dari BizzVest, dilanjutkan dengan faq dari pengguna berupa pertanyaan yang dikirimkan melalui form, dan yang terakhir adalah form untuk mengirimkan pertanyaan. Pada implementasi mobile app menggunakan flutter, modul faq ini juga akan menerapkan ketiga bagian tersebut. 

Modul ini akan menerapkan widget untuk layout, seperti menggunakan widget Container, Align, Center, Padding, dan lain sebagainya agar posisi dari widget terorganisir dengan baik. Modul ini akan menerapkan widget untuk input dengan memanfaatkan widget Form dan FormField untuk menerima input dari user ketika ingin memasukkan nama dan pertanyaan mereka. Untuk menerapkan Event handling, modul ini akan menggunakan widget OnChanged yang akan merespon ketika user memasukkan field tertentu berupa warning, serta OnPressed pada button “Kirimkan pertanyaan” untuk mengirimkan pertanyaan pada form tersebut dan menampilkannya pada bagian faq dari pengguna.

Untuk pemanggilan Asynchronous ke Web Service Django, tampilan faq dari pengguna akan memanggil JSON dari Web Service Django berdasarkan pertanyaan dan nama penanya yang telah dimasukkan pada database Django sebelumnya ketika Proyek Tengah Semester melalui Heroku. Kemudian, data JSON yang telah didapatkan tersebut nantinya akan diolah dan ditampilkan pertanyaannya dan nama penanya tersebut pada tampilan mobile app dalam kumpulan card dengan widget ListView. 


