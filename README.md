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

### 1) Modul home_page (Ahmad Ghozi Fidinillah)
Modul ini merupakan implementasi halaman _homepage_ dari aplikasi BizzVest. Beberapa bagian utama pada modul ini yaitu info mengenai BizzVest, dan fitur kirim pesan ke BizzVest. Secara umum, modul ini akan mengimplementasikan _widget layout _seperti Center, Padding, dan lain sebagainya. Info mengenai BizzVest akan mengimplementasikan beberapa kombinasi widget, contohnya widget Text. Fitur kirim pesan ke BizzVest akan mengimplementasikan _widget_ Form untuk menerima input pesan dari pengguna, lalu ditambah tombol “Kirim Pesan” yang menerapkan Event Handling yaitu onPressed, dan akan dilakukan pemanggilan _Asynchronus_ ke Web Service Django untuk memberitahukan bahwa pesan telah terkirim. Lalu, dilakukan request ke Web Service Django untuk mendapatkan data pesan yang baru dikirim dalam bentuk JSON, yang kemudian akan diolah agar dapat ditampilkan di aplikasi mobile.

### 2) Modul my_profile (Raihansyah Yoga Adhitama)


### 3) Modul faq atau Frequently Ask Question (Nandhita Zefania Maharani)
Modul _Frequently Ask Question_ akan memberikan jawaban dari pertanyaan-pertanyaan terkait BizzVest. Modul ini akan diimplementasikan menjadi _mobile app _dari website yang telah dibuat dengan menggunakan _framework_ Django. Pada website BizzVest yang telah di_ deploy_ di Heroku sebelumnya, modul faq ini terdiri dari 3 bagian, yaitu faq utama berupa pertanyaan umum yang resmi dari BizzVest, dilanjutkan dengan faq dari pengguna berupa pertanyaan yang dikirimkan melalui form, dan yang terakhir adalah form untuk mengirimkan pertanyaan. Pada implementasi _mobile app _menggunakan flutter, modul faq ini juga akan menerapkan ketiga bagian tersebut dan dapat diakses pada appbar yang ada di bagian bawah aplikasi. 

Modul ini akan menerapkan _widget_ untuk _layout_, seperti menggunakan _widget_ Container, Align, Center, Padding, dan lain sebagainya agar posisi dari _widget_ terorganisir dengan baik. Modul ini akan menerapkan _widget_ untuk _input_ dengan memanfaatkan _widget_ Form dan FormField untuk menerima _input_ dari user ketika ingin memasukkan nama dan pertanyaan mereka. Untuk menerapkan _Event handling_, modul ini akan menggunakan _widget_ OnChangedyang akan merespon ketika user memasukkan _field_ tertentu berupa _warning_, serta OnPressed pada button “Kirimkan pertanyaan” untuk mengirimkan pertanyaan pada form tersebut dan menampilkannya pada bagian faq dari pengguna.

Untuk pemanggilan _Asynchronous_ ke Web Service Django, tampilan faq dari pengguna akan memanggil JSON dari Web Service Django berdasarkan pertanyaan dan nama penanya yang telah dimasukkan pada _database_ Django sebelumnya ketika Proyek Tengah Semester melalui Heroku. Kemudian, data JSON yang telah didapatkan tersebut nantinya akan diolah dan ditampilkan pertanyaannya dan nama penanya tersebut pada tampilan_ mobile app_ dalam kumpulan card dengan widget ListView. 

### 4) Modul halaman_toko (Immanuel)
Modul halaman toko, atau dapat disebut juga modul halaman perusahaan, merupakan modul yang menampilkan berbagai macam informasi mengenai suatu perusahaan yang sedang membutuhkan dana dari para investor. Pada modul ini, berbagai macam informasi mengenai perusahaan akan ditampilkan, misalnya seperti nama merek, foto-foto, besarnya dana yang diperlukan, hingga persentase saham yang sudah terkumpul. Pada modul ini, terdapat pula 2 fungsionalitas lainnya, yakni halaman untuk mendaftarkan perusahaan baru dan halaman untuk mengedit daftar dan urutan foto.

Untuk memberikan tampilan yang rapi, modul ini akan memanfaatkan berbagai macam widget layout, misalnya Center, Align, Container, maupun Column.
Pada halaman yang berfungsi untuk mendaftarkan perusahaan baru, input data yang diberikan oleh user akan diterima oleh widget Form maupun FormField. Setelah data diterima, data-data tersebut akan dikirimkan ke aplikasi django dengan memanfaatkan _asynchronous_ _call_ pada _library_ http. Hal yang sama juga berlaku untuk halaman yang berfungsi untuk mengedit daftar toko. Pada halaman ini, event dari user seperti  onDoubleTap akan ditangani, diproses, dan hasilnya akan dikirimkan ke web django.

### 5) Modul mulai_invest (Ivan Phanderson)
Mulai_invest merupakan modul tempat dimana investor meraup keuntungan yang merupakan salah satu tujuan awal mereka berkunjung pada website ini dan juga menjadi sarana pembantu bagi pelaku usaha (Pemilik UMKM dan petani) yang kesulitan akibat dampak pandemi Covid-19. Pada modul ini, akan ditampilkan informasi keuangan perusahaan yang bersangkutan dalam bentuk grafik, informasi saham perusahaan tersebut, dan beberapa informasi penting lainnya yang dapat membantu investor untuk mengambil keputusan yang tepat. 

Modul ini akan mengimplementasikan _widget_ untuk _layout_ seperti Container, Row, Column, dan Center, _widget_ untuk _input_ yaitu TextFromField yang menerima masukan jumlah lembar saham yang ingin ditanamkan oleh investor, Event Handling berupa OnPressed yang dipakai ketika user menekan tombol “Beli” atau “Batal”, dan yang terakhir adalah menerapkan pemanggilan _Asynchronous_ ke Web Service Django untuk memanggil data dari _database_ seperti informasi perusahaan yang dikunjungi oleh investor, melakukan penyimpanan total saham yang dibeli ketika melakukan pembelian saham, yang mana pemanggilan ini akan mengakibatkan Web Service Django mengembalikan data response JSON untuk diolah dan ditampilkan di _mobile app_.


### 6) Modul daftar_toko (Azzam Labib Hakim)
Pada implementasi berbentuk web daftar_toko terdapat _layout_ utama yang terdiri dari _footer_, _body_, dan navbar. Pada bagian body terdapat _input_ berupa search bar untuk mencari nama perusahaan, nama toko atau saham yang jika dicari akan menampilkan _card_ nama toko, nama perusahaan atau card yang berisi saham yang sesuai. Selain itu terdapat kumpulan _card_ toko yang jika diklik akan mengarahkan pengguna ke halaman toko yang dimaksud. 

Oleh karena itu, untuk mengubah implementasi menjadi bentuk mobile, layoutnya dimodifikasi sehingga _footer_ ditiadakan, navbar menjadi bagian bawah, dan body menjadi lebih ramping sehingga menampilkan judul “BizzVest” dan _login/signup_ serta search bar di bagian paling atas dan dibawahnya terdapat _card_ yang ditampilkan dalam satu kolom yang dapat di _scroll_ ke bawah dan te-_refresh_ otomatis saat mencapai paling bawah page yang di _scroll_. Rencananya tampilan daftar toko akan menggunakan ListView dan search bar akan menggunakan TextFormField.

Implementasi pemanggilan data hanya sebagian besar sama, yaitu memanggil dari _database_ yang juga menampilkan konten untuk bentuk web. Pemanggilan data untuk mengisi card menggunakan konsep pemanggilan _Asynchronous_ ke Web Service Django yang akan mengembalikan data berbentuk JSON yang dapat diubah menjadi bentuk yang dimengerti Flutter. Lalu, jika card tersebut di klik, maka dengan onPressed atau onClick akan diarahkan ke halaman_toko. Perbedaan yang mungkin terdapat pada konversi program ke dalam flutter-dart serta penerapan autentikasi. 

### 7) Modul login_signup (Raissa Tito Safaraz)
Pada modul ini, terdapat _login page_ dan _signup page_. _Sign up page_ akan meminta _user_ untuk mengisi data utama seperti _username, email address,_ dan _password_. untuk _login page, user_ akan diminta untuk mengisi _username_ dan _password_ yang mereka telah daftarkan sebelumnya. Tampilan yang dimiliki _login_ dan _sign up page_ kurang lebih sama seperti yang telah dibuat di _website_ yang lalu. page ini akan menggunakan _layout column_ dimana input data login atau signup akan diminta menggunakan _widget_ Form melalui TextFormField. selain itu, ada juga button daftar atau masuk dengan menerapkan event handling onPressed yang akan menyimpan data ke database Django untuk _sign up_ dan _request_ data untuk _login_. untuk menuju ke _sign up_ dan _login page_ ini dapat diakses melalui _appbar_ yang ada di setiap _page_ dari masing masing modul yang lain.

