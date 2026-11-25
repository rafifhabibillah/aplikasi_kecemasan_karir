# Arahku — Aplikasi Kecemasan Karier

Aplikasi mobile (Flutter) untuk membantu siswa mengukur dan mengelola kecemasan karier.

**Tagline:** Kenali cemas kariermu, ambil langkah yang lebih jelas.

## Fitur saat ini

- Onboarding singkat + login demo (nama + NIS)
- Asesmen kecemasan karier (dengan consent) + skor per aspek + riwayat
- **Mindfulness**: napas box, grounding 5-4-3-2-1, jeda mindful karier, body scan, pilah khawatir, kekuatan diri
- **Check-in harian** (satu entri per hari, bisa diperbarui)
- **Jurnal refleksi** dengan prompt + hapus entri
- **Langkah kecil** perencanaan karier
- **Progres**: streak, sparkline 7 hari, kalender aktivitas, export JSON penelitian
- Materi edukasi dengan CTA ke latihan terkait
- Rekomendasi pasca-asesmen (satu langkah utama per level)

Semua data masih tersimpan **lokal di perangkat** (siap diganti backend nanti).

## Cara menjalankan

```bash
flutter pub get
flutter run
```

Build APK:

```bash
flutter build apk --release
```

APK keluar di `build/app/outputs/flutter-apk/app-release.apk`.

Setelah ganti logo, regenerate launcher icon:

```bash
dart run flutter_launcher_icons
```

## Struktur penting

| Path | Isi |
|---|---|
| `lib/brand/app_brand.dart` | Nama & tagline brand |
| `lib/data/sample_instrument.dart` | Item & dimensi asesmen |
| `lib/services/scoring_service.dart` | Rumus skor & cut-off |
| `lib/data/mindfulness_practices.dart` | Latihan & prompt jurnal |
| `lib/data/sample_articles.dart` | Materi edukasi |
| `lib/screens/` | UI utama |

## Catatan

Latihan mindfulness bersifat pendukung, bukan pengganti konseling profesional.
Instrumen asesmen masih draft sampai peneliti tesis mengirim versi final.
