# Upload Ultra.X ke Google Play

## Status project saat ini

- Nama aplikasi Android sudah tampil sebagai `Ultra.X`.
- Release signing sudah mendukung `android/key.properties`.
- Package Android sudah diset ke `com.ti24a6.app14`.
- Upload keystore sudah disiapkan untuk build release lokal.

## 1. Package name final

Package yang dipakai saat ini:

- `com.ti24a6.app14`

## 2. Buat upload keystore

Contoh command:

```powershell
keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 4096 -validity 10000 -alias upload
```

Simpan file `upload-keystore.jks` di root project.

## 3. Buat file key.properties

Copy:

- `android/key.properties.example`

menjadi:

- `android/key.properties`

Isi contoh:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

## 4. Naikkan versi aplikasi

Edit file:

- `pubspec.yaml`

Contoh:

```yaml
version: 1.0.1+2
```

## 5. Build Android App Bundle

```powershell
flutter clean
flutter pub get
flutter build appbundle
```

Output:

- `build/app/outputs/bundle/release/app-release.aab`

## 6. Siapkan item Play Console

- Developer account Google Play
- Nama aplikasi
- Deskripsi singkat dan lengkap
- Ikon 512x512
- Feature graphic 1024x500
- Screenshot HP
- Email support
- URL privacy policy
- Kategori aplikasi
- Data safety form
- Content rating
- App access declaration jika dibutuhkan

## 7. Upload ke Play Console

Urutan umum:

1. Create app
2. Isi store listing
3. Isi App content
4. Setup App signing
5. Upload file `.aab`
6. Buat internal test / closed test
7. Review lalu publish

## Catatan penting

- Aplikasi baru di Google Play harus upload format `AAB`, bukan APK.
- Jangan publish dengan package `com.example.widget`.
- Jangan publish pakai debug signing key.
