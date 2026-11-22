# ArahTenang — Aplikasi Kecemasan Karier

Aplikasi mobile (Flutter) untuk membantu siswa mengukur dan mengelola kecemasan karier.

## Fitur saat ini

- Asesmen kecemasan karier + skor per aspek + riwayat
- **Mindfulness**: napas box, grounding 5-4-3-2-1, jeda mindful karier
- **Check-in harian** tingkat kecemasan
- **Jurnal refleksi** dengan prompt siap pakai
- **Langkah kecil** perencanaan karier
- **Progres**: streak, aktivitas, ringkasan
- Materi edukasi (termasuk mindfulness)
- Rekomendasi pasca-asesmen sesuai level hasil

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

## Struktur penting

| Path | Isi |
|---|---|
| `lib/data/sample_instrument.dart` | Item & dimensi asesmen |
| `lib/services/scoring_service.dart` | Rumus skor & cut-off |
| `lib/data/mindfulness_practices.dart` | Latihan & prompt jurnal |
| `lib/data/sample_articles.dart` | Materi edukasi |
| `lib/screens/` | UI utama |

## Catatan

Latihan mindfulness bersifat pendukung, bukan pengganti konseling profesional.
Instrumen asesmen masih draft sampai peneliti tesis mengirim versi final.
# aplikasi_kecemasan_karir
