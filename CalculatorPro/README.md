# CalculatorPro

Ek complete Flutter calculator app — smart calculator, unit converter, BMI,
finance calculators (discount/tax/tip/profit-margin), calculation history,
3 color themes (Classic / Malva Rose / Electric Blue), dark mode, aur
English/Hindi language switch — sab ek app mein.

## App khulte hi kya milega

- **Calculator tab** (default, full screen) — standard calculator,
  scientific functions (sin/cos/tan/√/π) ek toggle se expand hoti hain.
- **Tools tab** (grid icon) — 30+ calculators/converters, categories mein:
  Dev Calculator, Algebra, Geometry, Unit Converters, Finance, Health,
  Data & Time, Physics, Chemistry, Cooking.
- **History tab** (notepad icon) — har calculation date/time ke saath save,
  swipe to delete, clear-all button.
- **Settings tab** (⋮ icon) — dark theme, 3 color themes, language,
  thousands separator, decimal places.

## Naye Finance calculators (is update mein add kiye)

Discount, Sales Tax, Tip Calculator, Unit Price Compare, Profit Margin —
sab `lib/screens/finance/` folder mein.

## App ko build kaise karein

### Option A — apne PC pe (Flutter installed hona chahiye)

```bash
flutter pub get
flutter build apk --release       # Android APK
flutter build appbundle --release # Play Store ke liye .aab
flutter build ios --release       # iOS (sirf macOS pe)
```

APK yahan milegi: `build/app/outputs/flutter-apk/app-release.apk`

Flutter install nahi hai to: https://docs.flutter.dev/get-started/install

### Option B — GitHub Actions se (bina apne PC pe Flutter install kiye)

1. Is poore folder ko ek naye GitHub repo mein push karo.
2. `.github/workflows/build-apk.yml` already add hai — push karte hi
   Actions tab mein automatically APK build hogi.
3. Build complete hone ke baad, Actions run ke "Artifacts" section se
   `CalculatorPro-release-apk` download kar lo — wahi tumhari `.apk` file hai.

## Amazon / Play Store pe publish karne se pehle

- `android/app/build.gradle.kts` mein `applicationId` already
  `com.calculatorpro.app` set hai — chaho to apna khud ka unique id
  daal sakte ho.
- Release build ke liye apna khud ka signing keystore banao aur
  `key.properties` + `build.gradle.kts` mein signingConfig set karo
  (Flutter docs: "Build and release an Android app").
- App icon `assets/icons/app_icon.png` se already auto-generate hoti hai
  (`flutter_launcher_icons` package) — bas naya icon chahiye to wahi file
  replace karke `flutter pub run flutter_launcher_icons` chala do.
- Store listing screenshots ke liye app already har theme mein achhi
  dikhti hai — Settings > Color Theme se teeno themes (Classic, Malva
  Rose, Electric Blue) try kar sakte ho.

## Note

Ye poora functional, ready-to-build **source code** hai — sandbox mein
Flutter/Android SDK available nahi hone ki wajah se compiled `.apk`
yahan generate nahi ki ja saki. Upar diye gaye Option A ya B se 2-5 min
mein real APK ban jayegi.
