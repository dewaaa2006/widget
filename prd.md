# Product Requirements Document

## Product
`Ultra.X`

## Document Status
- Version: `1.0`
- Status: `Working Draft`
- Product Type: `Mobile app`
- Platform: `Flutter`
- Region: `Indonesia`
- Language: `Bahasa Indonesia`
- Currency: `Rupiah`

## 1. Overview
`Ultra.X` adalah aplikasi mobile premium untuk top up dan pembayaran digital dengan fokus utama pada transaksi harian yang cepat, aman, dan terasa mewah. Produk ini menggabungkan kepraktisan utility telecom dengan kualitas pengalaman ala fintech premium.

Target akhirnya bukan sekadar demo visual. Produk harus terasa seperti aplikasi nyata yang siap dipresentasikan ke client, investor, atau diteruskan ke tahap production.

## 2. Problem Statement
Pengguna di Indonesia sering memakai beberapa aplikasi berbeda untuk kebutuhan digital harian seperti:
- isi pulsa
- beli paket data
- top up saldo
- token listrik
- pembayaran digital

Masalah utama yang ingin diselesaikan:
- alur transaksi terasa tersebar dan tidak efisien
- UI aplikasi utilitas sering terasa generik dan tidak premium
- proses checkout multi-item jarang jelas dan nyaman
- trust saat transaksi pending/gagal sering buruk
- repeat order, voucher, dan nomor favorit sering tidak terhubung dengan baik

## 3. Product Vision
Membangun aplikasi top up digital terbaik di kelasnya untuk pasar Indonesia dengan prinsip:
- cepat
- jelas
- aman
- premium
- polished
- conversion-focused

## 4. Goals
### Business Goals
- meningkatkan conversion dari pemilihan produk ke pembayaran
- meningkatkan repeat transaction lewat riwayat, favorit, dan repeat order
- meningkatkan user trust lewat transaction states yang jelas
- meningkatkan AOV lewat cart multi-item dan promo recommendation

### Product Goals
- memungkinkan top up dan pembayaran selesai dalam sangat sedikit langkah
- menyediakan cart dan checkout multi-item yang mudah dipahami
- membuat pengalaman terlihat high-end dan investor-ready
- menyediakan state realistis seperti pending, gagal, item unavailable, voucher invalid, dan insufficient balance

## 5. Non-Goals
- integrasi payment gateway production nyata
- OTP/SMS provider nyata
- backend transaksi real-time
- contact picker native device
- upload foto dari kamera/gallery native production-ready

Catatan:
Untuk tahap ini, fitur-fitur tersebut boleh dimodelkan sebagai simulated production flow selama perilaku UI/UX-nya terasa realistis.

## 6. Target Users
### Primary Users
- pengguna mobile-first usia 17-40 tahun
- pengguna aktif top up pulsa/data
- pengguna dompet digital dan pembayaran harian
- pengguna yang sensitif pada kecepatan dan kejelasan flow

### Secondary Users
- stakeholder bisnis yang menilai kesiapan demo
- designer/product owner yang ingin melihat scope aplikasi nyata
- investor/client yang ingin melihat kualitas product direction

## 7. Core Value Proposition
- semua kebutuhan top up digital dalam satu aplikasi
- premium experience tanpa mengorbankan kecepatan
- cart dan checkout yang mendukung multi-item
- transaction feedback yang jelas dan meyakinkan
- repeat order dan favorit untuk transaksi super cepat

## 8. Success Metrics
### North Star
- successful transaction completion rate

### Supporting Metrics
- add-to-cart rate
- checkout start rate
- checkout completion rate
- repeat purchase rate
- voucher claim to usage rate
- time to complete top up
- failure recovery rate
- help ticket creation rate setelah transaksi gagal

## 9. Product Scope
### In Scope
- onboarding
- authentication
- beranda premium
- pulsa
- paket data
- top up saldo
- token listrik
- promo center
- voucher
- cart
- checkout
- payment processing
- success/pending/failed result
- transaction history
- transaction detail
- repeat order
- notifications
- loyalty/reward/referral
- favorites
- profile
- profile edit
- security
- saved payment methods
- help and ticketing
- settings

### Out of Scope for Current Phase
- real payment settlement
- real analytics dashboard backend
- KYC verification nyata
- native biometric implementation penuh

## 10. Product Principles
- premium by default
- minimal friction
- trust at every step
- clear next action
- motion with purpose
- consistent financial hierarchy
- realistic application states

## 11. Information Architecture
- Splash
- Onboarding
- Login / Register / OTP
- Home
- Search
- Pulsa
- Paket Data
- Top Up Saldo
- Token Listrik
- Promo Center
- Voucher
- Cart
- Checkout
- Payment Processing
- Result
- History
- Transaction Detail
- Notifications
- Rewards
- Referral
- Favorites
- Profile
- Edit Profile
- Security
- Payment Methods
- Help / FAQ
- Ticket Submission
- Settings

## 12. Key User Flows
### Flow A: First-Time User
1. User membuka app
2. Splash tampil
3. User melihat onboarding
4. User register
5. User OTP verification
6. User masuk ke beranda

### Flow B: Multi-Item Purchase
1. User membuka halaman Pulsa
2. User input nomor
3. Operator terdeteksi
4. User pilih nominal
5. User add to cart
6. User pindah ke Paket Data
7. User pilih paket
8. User add to cart
9. User buka keranjang
10. User pilih item yang ingin dibayar
11. User pasang voucher
12. User lanjut checkout
13. User pilih metode bayar
14. User konfirmasi pembayaran
15. User melihat processing state
16. User melihat success / partial success / pending / failed
17. User buka history

### Flow C: Direct Buy
1. User pilih produk
2. User klik beli sekarang
3. User masuk checkout single-item
4. User bayar
5. User melihat hasil transaksi

### Flow D: Repeat Order
1. User buka riwayat
2. User buka detail transaksi
3. User pilih beli lagi
4. User masuk checkout ulang

### Flow E: Favorites
1. User buka profil
2. User buka favorites
3. User pilih nomor favorit
4. User quick buy pulsa/data

## 13. Functional Requirements
### 13.1 Authentication
- user dapat login
- user dapat register
- user dapat OTP verification
- user dapat logout

### 13.2 Home
- menampilkan greeting personal
- menampilkan wallet balance
- user dapat hide/show saldo
- menampilkan quick actions
- menampilkan promo
- menampilkan continue from cart
- menampilkan recent transactions
- menampilkan reward dan referral snippet

### 13.3 Pulsa
- input nomor HP
- auto detect operator Indonesia
- pilih nominal cepat
- lihat harga promo
- add to cart
- buy now

### 13.4 Paket Data
- input nomor
- auto detect operator
- tab kategori paket
- filter paket
- expand detail paket
- add to cart
- buy now

### 13.5 Top Up Saldo
- tampilkan saldo saat ini
- pilih nominal cepat
- custom nominal
- pilih metode top up
- lanjut checkout

### 13.6 Token Listrik
- input ID pelanggan / nomor meter
- validasi pelanggan
- tampilkan nama pelanggan dan tarif/daya
- pilih nominal
- add to cart
- buy now

### 13.7 Promo Center
- tampilkan promo hero
- support filter promo
- user bisa claim promo
- promo claim menambahkan voucher ke daftar voucher user

### 13.8 Voucher
- input kode voucher
- pilih voucher dari daftar
- tampilkan state applied / invalid

### 13.9 Cart
- menyimpan item dari beberapa layanan
- support select item
- support select all
- support remove item
- support edit item
- support voucher
- block checkout jika tidak ada item valid
- block checkout jika item selected unavailable

### 13.10 Checkout
- support single item
- support multi item
- tampilkan ringkasan biaya
- tampilkan voucher aktif
- pilih metode pembayaran
- tampilkan insufficient balance state
- konfirmasi pembayaran

### 13.11 Payment Processing
- tampilkan step progress
- tampilkan loader
- jangan izinkan user dismiss sembarangan

### 13.12 Result
- support success
- support pending
- support partial success
- support failed
- support deep link ke detail transaksi

### 13.13 History
- list semua transaksi
- filter berdasarkan status
- buka detail transaksi

### 13.14 Transaction Detail
- tampilkan detail transaksi
- tampilkan breakdown biaya
- tampilkan payment method
- support beli lagi
- support hubungi CS

### 13.15 Profile
- tampilkan data user
- user bisa edit nama
- user bisa edit email
- user bisa edit nomor
- user bisa ganti avatar/foto profil simulasi

### 13.16 Payment Methods
- tampilkan metode tersimpan
- user bisa tambah metode baru

### 13.17 Favorites
- tampilkan nomor tersimpan
- quick buy pulsa
- quick buy data
- hapus favorit

### 13.18 Help
- tampilkan FAQ
- tampilkan channel support
- support ticket submission

## 14. State Requirements
Semua flow penting harus punya state berikut jika relevan:
- loading
- success
- empty
- error
- invalid input
- disabled CTA
- pending
- failed
- insufficient balance
- item unavailable
- no internet
- voucher invalid
- cart empty
- saved cart
- no history
- no favorites
- partial success
- retry payment
- payment expired
- duplicate warning

## 15. UX Requirements
- langkah berikutnya harus selalu jelas
- CTA utama harus sangat dominan
- harga, diskon, admin fee, dan total harus mudah dibedakan
- cart dan checkout tidak boleh membingungkan
- feedback setelah action harus instan
- pending/gagal harus tetap terasa aman dan tidak panik
- repeat order harus sangat cepat

## 16. Visual Requirements
### Design Direction
- premium
- editorial
- clean
- layered
- airy
- expensive
- modern

### Color
- Background: `#f7f9ff`
- Surface: `#f1f4f9`
- Elevated surface: `#e6e8ee`
- Card: `#ffffff`
- Text primary: `#181c20`
- Text secondary: `#404850`
- Primary dark blue: `#005d90`
- Accent blue: `#0077b6`
- Warm accent: `#F57C00`

### Typography
- headline style: Plus Jakarta Sans feel
- body style: Inter feel
- nominal dan CTA harus punya hierarchy kuat

### Motion
- splash reveal
- onboarding slide
- staggered card entrance
- hero shimmer
- spring interaction
- add-to-cart feel
- bottom sheet reveal
- success morph
- progress motion
- subtle toast animation

## 17. Data Requirements
### Operators
- Telkomsel
- XL Axiata
- Indosat
- Tri
- Smartfren

### Pulsa
- 5.000
- 10.000
- 15.000
- 20.000
- 25.000
- 50.000
- 100.000

### Payment Methods
- Saldo Ultra.X
- QRIS
- BCA VA
- Mandiri VA
- GoPay
- OVO
- DANA

### Promo Examples
- cashback 10%
- diskon Rp2.000
- bebas admin
- voucher pengguna baru

## 18. Technical Notes
- built with Flutter
- current phase uses local simulated state
- app state saat ini dikelola in-memory
- future phase dapat dipindah ke state management dan backend persistence yang lebih formal

## 19. Risks
- simulated flows bisa terlihat lengkap tetapi belum production-integrated
- state in-memory belum tahan app restart
- route argument handling harus selalu defensif
- multi-item checkout punya complexity tinggi pada partial result handling

## 20. Release Readiness Checklist
- [ ] semua route aman dari null argument runtime
- [ ] semua placeholder utama diganti dengan behavior nyata
- [ ] semua core flow lolos smoke test manual
- [ ] cart to checkout flow stabil
- [ ] promo claim to voucher usage stabil
- [ ] profile edit tersimpan dengan benar
- [ ] history dan transaction detail sinkron
- [ ] visual polish konsisten di seluruh app

## 21. Immediate Next Steps
1. stabilkan semua runtime flow utama
2. rapikan placeholder sekunder menjadi feature-ready
3. tambahkan smoke/integration tests untuk flow cart-checkout
4. tambahkan persistence untuk user, cart, voucher, dan riwayat
5. lanjutkan polish motion, reward, help, notification, dan retry flow

