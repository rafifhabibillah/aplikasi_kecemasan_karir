# Rangkuman Proyek ArahTenang

Dokumentasi perjalanan chat dan pekerjaan teknis dari awal sampai kondisi terkini.

**Tanggal update:** 22 November 2026  
**Repo:** `aplikasi_kecemasan_karir`  
**Nama aplikasi:** ArahTenang

---

## 1. Konteks awal

Client (teman Achmad) membutuhkan aplikasi kecemasan karier untuk keperluan tesis.

### Ringkasan kebutuhan dari chat awal

| Pertanyaan | Jawaban client |
|---|---|
| Platform | Mobile |
| Pengguna | Siswa |
| Requirement / rancangan | Masih perlu dibuat dari awal |
| Kuesioner / instrumen | Belum ada (masih penyusunan Bab 1–3) |
| Referensi aplikasi | Belum ada |
| Dokumentasi proposal | Belum dikirim |

Kondisi awal project: **greenfield** (belum ada kode / dokumen teknis di workspace).

---

## 2. Keputusan produk

| Aspek | Keputusan |
|---|---|
| Nama brand | **ArahTenang** |
| Tagline arah | Tenangkan pikiran, arahkan karier |
| Konsep utama | Asesmen + edukasi + mindfulness / intervensi ringan |
| Stack | Flutter (prioritas Android) |
| Penyimpanan data | Lokal di perangkat (`SharedPreferences`) |
| Instrumen asesmen | Placeholder — mudah diganti saat tesis final |
| Backend | Belum; disiapkan untuk fase berikutnya |

### Positioning ke client

Karena Bab 1–3 dan instrumen belum final, pengerjaan dimulai dari **blueprint + MVP yang bisa didemo**, bukan menunggu seluruh proposal selesai. Validitas instrumen tetap tanggung jawab peneliti.

---

## 3. Estimasi yang pernah dibahas

### Paket 1 — MVP Penelitian (disarankan)

- Login siswa, kuesioner, skoring, hasil, edukasi, riwayat, admin sederhana, export
- Durasi: **± 4–6 minggu**
- Harga acuan: **Rp 6.000.000 – Rp 10.000.000**

### Paket 2 — Full Research App

- Pre/post test, dashboard statistik, intervensi, notifikasi, PDF, multi-sekolah, iOS
- Durasi: **± 7–10 minggu**
- Harga acuan: **Rp 12.000.000 – Rp 18.000.000**

### Yang disarankan ditunda di awal

- Chat / booking BK
- AI chatbot konseling
- Offline mode penuh
- Role orang tua

---

## 4. Timeline pekerjaan teknis

### Fase 1 — Fondasi prototipe

Yang dikerjakan:

- Scaffold project Flutter
- Tema dasar & struktur folder
- Alur utama:
  - Splash
  - Login demo (nama + NIS)
  - Beranda
  - Asesmen 12 item draft (4 dimensi)
  - Hasil skor + kategori
  - Materi edukasi
  - Riwayat asesmen
- Skoring otomatis (cut-off placeholder)
- Build APK release pertama (~48 MB)

Tujuan fase ini: punya demo yang jalan **tanpa menunggu instrumen client**.

### Fase 2 — Upgrade jadi app lebih berguna

Ditambahkan modul wellbeing:

- Check-in harian (skala kecemasan 1–5)
- Jurnal refleksi + prompt siap pakai
- Langkah kecil perencanaan karier
- Mindfulness awal (napas, grounding, jeda mindful)
- Navigasi 4 tab: **Beranda · Latihan · Refleksi · Progres**
- Streak & log aktivitas
- Rekomendasi pasca-asesmen sesuai level hasil

### Fase 3 — Brand & polish UI

- Icon launcher custom (bukan default Flutter)
- Nama aplikasi di perangkat: **ArahTenang**
- Tipografi Manrope
- Background gradient, panel lebih halus, transisi fade
- Redesign splash & login agar lebih profesional
- APK rebuild (~50 MB)

### Fase 4 — Mindfulness interaktif & UX keseluruhan

Masalah yang ditangani:

- Latihan mindfulness terasa membosankan (hanya instruksi teks)
- Visual napas berupa lingkaran besar terasa aneh / kaku

Perbaikan:

- **Napas box:** titik berjalan di jalur kotak + indikator fase
- **Grounding:** pilih chip indra (bukan menulis panjang)
- **Jeda mindful:** pilih kekhawatiran + respons kecil
- Latihan baru:
  - Body scan singkat
  - Pilah rasa khawatir (bisa dikendalikan vs di luar kendali)
  - Ambil 3 kekuatan diri
- Hub latihan dikelompokkan: Tenangkan tubuh / Fokus pikiran / Arah karier
- Polish asesmen, hasil, refleksi, edukasi
- APK terbaru rebuild lagi (~50 MB)

---

## 5. Fitur aplikasi saat ini

### Inti asesmen

1. Login demo (nama + NIS)
2. Asesmen kecemasan karier
3. Skor total + skor per aspek
4. Kategori: rendah / sedang / tinggi
5. Riwayat asesmen
6. Rekomendasi latihan sesuai level hasil

### Latihan tenang (mindfulness)

1. Napas box interaktif
2. Grounding 5-4-3-2-1 interaktif
3. Body scan singkat
4. Jeda mindful karier
5. Pilah rasa khawatir
6. Ambil 3 kekuatan diri

### Refleksi & aksi

1. Check-in harian
2. Jurnal refleksi
3. Langkah kecil karier
4. Materi edukasi (termasuk topik mindfulness)

### Progres

1. Streak aktivitas
2. Ringkasan check-in / langkah / asesmen
3. Log aktivitas terbaru

---

## 6. Yang belum dikerjakan

Siap dilanjutkan setelah feedback client / kebutuhan tesis lebih jelas:

- [ ] Backend (Firebase / Supabase / custom)
- [ ] Admin web untuk peneliti / guru BK
- [ ] Export CSV / PDF laporan
- [ ] Auth akun sekolah sungguhan
- [ ] Instrumen final dari tesis (item, dimensi, rumus, cut-off)
- [ ] Flow pre-test / post-test otomatis (jika wajib)
- [ ] Multi-sekolah / multi-kelas
- [ ] Publish Play Store production
- [ ] Build iOS

---

## 7. Struktur file penting

| Path | Fungsi |
|---|---|
| `lib/main.dart` | Entry point aplikasi |
| `lib/theme/app_theme.dart` | Warna, tipografi, tema |
| `lib/data/sample_instrument.dart` | Item & dimensi asesmen (placeholder) |
| `lib/services/scoring_service.dart` | Rumus skor & cut-off |
| `lib/data/mindfulness_practices.dart` | Daftar latihan + prompt jurnal |
| `lib/data/sample_articles.dart` | Materi edukasi |
| `lib/services/session_service.dart` | Login lokal + riwayat asesmen |
| `lib/services/wellbeing_store.dart` | Check-in, jurnal, langkah, aktivitas |
| `lib/screens/` | Seluruh layar UI |
| `lib/widgets/` | Komponen bersama (brand, panel, practice UI) |
| `assets/branding/app_icon.png` | Icon aplikasi |
| `README.md` | Cara menjalankan singkat |
| `DOKUMENTASI_PROYEK.md` | Ringkasan proyek ini |

---

## 8. Cara menjalankan & build

### Jalankan di perangkat / emulator

```bash
cd E:\Projectq\aplikasi_kecemasan_karir
flutter pub get
flutter run
```

### Build APK release

```bash
flutter build apk --release
```

Output APK:

```text
build\app\outputs\flutter-apk\app-release.apk
```

Ukuran terakhir: sekitar **50 MB**.

---

## 9. Status terhadap client

- Client masih di tahap penyusunan Bab 1–3
- Instrumen ilmiah belum final
- Aplikasi sudah cukup untuk **demo alur, uji coba lapangan awal, dan pengumpulan feedback UX**
- Penyesuaian berikutnya mengikuti:
  1. Feedback client terhadap APK
  2. Draft instrumen (item, dimensi, skoring, cut-off)
  3. Kebutuhan pre/post test & admin peneliti

---

## 10. Next steps yang disarankan

1. **Kirim APK terbaru** ke client untuk dicoba
2. **Kunci scope tertulis** (MVP vs add-on) agar tidak scope creep
3. **Minta draft instrumen** meski sementara
4. Setelah instrumen ada → update `sample_instrument.dart` + `scoring_service.dart`
5. Jika tesis butuh data agregat → kerjakan **admin + export CSV**
6. Baru setelah uji coba stabil → bahas Play Store / iOS

---

## 11. Kesimpulan singkat

Dari kondisi “buat aplikasi tesis tapi belum ada dokumen”, project ini sudah berkembang menjadi aplikasi mobile **ArahTenang** yang dapat didemo:

- mengukur kecemasan karier,
- memberi interpretasi hasil,
- menawarkan latihan mindfulness interaktif,
- mendukung refleksi harian dan langkah kecil,
- siap disesuaikan ketika feedback dan instrumen client tersedia.

---

*Dokumen ini dibuat sebagai ringkasan internal pengerjaan. Boleh dibagikan ke client sebagai lampiran progress jika diperlukan.*
