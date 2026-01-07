# Flutter uygulamanıza hoş geldiniz 👋

Bu depo artık Flutter tabanlı bir mobil uygulama projesidir. Eski Expo / React Native kodları, gerekirse bakabilmeniz için `legacy_expo/` klasörüne taşındı.

## Başlangıç

1. Flutter'ı kurun

   Flutter yüklü değilse resmi dokümantasyondan kurabilirsiniz:

   https://docs.flutter.dev/get-started/install

   Kurulumdan sonra:

   ```bash
   flutter --version
   ```

   komutu düzgün çalışıyorsa kurulum tamamdır.

2. Bağımlılıkları indirin

   Proje kök dizininde:

   ```bash
   flutter pub get
   ```

3. Uygulamayı çalıştırın

   Bağlı bir cihaz (fiziksel cihaz veya emulator/simulator) olduğu sürece:

   ```bash
   flutter run
   ```

   komutu Android veya iOS üzerinde uygulamayı başlatacaktır.

## Proje yapısı

Flutter ile çalışacağınız temel klasör ve dosyalar:

- `lib/main.dart` – Uygulamanın giriş noktası
- `lib/` – Widget'lar, sayfalar ve iş mantığı için Dart dosyaları
- `pubspec.yaml` – Paket bağımlılıkları ve asset tanımları

Eski Expo / React Native kodları:

- `legacy_expo/` altında tutulmaktadır.
  - `legacy_expo/app/`
  - `legacy_expo/components/`
  - `legacy_expo/hooks/`
  - vb.

Bu klasör, Flutter geçişi sırasında referans olarak kullanılabilir; yeni geliştirmeler Flutter tarafında yapılmalıdır.

## Faydalı bağlantılar

- [Flutter dokümantasyonu](https://docs.flutter.dev/)
- [Flutter paketleri (pub.dev)](https://pub.dev/)
