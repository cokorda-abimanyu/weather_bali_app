# weather_bali_app 🌤

Halo, saya Cok Gde Abimanyu Pradnyana Putra (2301010055) Mahasiswa Prodi Sistem Informasi dari Primakara University.
Berikut ini adalah aplikasi prakiraan cuaca sederhana berbasis Flutter yang menampilkan informasi cuaca untuk Bali dan kota lain di seluruh dunia. Data diambil dari **OpenWeather API** dan ditampilkan dalam antarmuka gelap modern dengan kartu cuaca utama, panel prakiraan harian, dan timeline suhu per jam.

## ✨ Fitur

- Cari cuaca berdasarkan **nama kota** (default: Denpasar)
- Informasi cuaca saat ini:
  - Suhu utama (°C)
  - Deskripsi cuaca (rain, clear, cloudy, dll.)
  - Kecepatan angin (m/s)
  - Kelembapan (%)
- Desain UI:
  - Tampilan utama berbentuk **card** gelap dengan sudut membulat
  - Ilustrasi awan + petir di tengah
  - Panel daftar cuaca harian di sisi kanan (dummy statis, siap dikembangkan)
  - Timeline suhu per jam di bagian bawah (dummy statis, siap dihubungkan ke API forecast)
- Sudah menggunakan **OpenWeather API** dengan satu endpoint cuaca saat ini

## 🧰 Teknologi

- [Flutter](https://flutter.dev/) (Dart)
- [OpenWeather API](https://openweathermap.org/)
- HTTP client: [`http` package](https://pub.dev/packages/http)
