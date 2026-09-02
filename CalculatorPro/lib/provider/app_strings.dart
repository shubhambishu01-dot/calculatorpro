import 'theme_provider.dart';

/// Minimal string table for the core app shell (Calculator tab, Tools hub,
/// History and Settings). The 25+ individual calculator/converter screens
/// keep their existing English labels.
class AppStrings {
    final AppLanguage selectedLanguage;
    const AppStrings(this.selectedLanguage);

    bool get _hi => selectedLanguage == AppLanguage.hindi;

  String get calculatorTab => _hi ? 'कैलकुलेटर' : 'Calculator';
  String get toolsTab => _hi ? 'टूल्स' : 'Tools';
  String get historyTab => _hi ? 'हिस्ट्री' : 'History';
  String get settingsTab => _hi ? 'सेटिंग्स' : 'Settings';

  String get history => _hi ? 'हिस्ट्री' : 'History';
  String get noHistoryYet =>
      _hi ? 'अभी तक कोई हिस्ट्री नहीं है।' : 'No history yet.';
  String get clearHistory => _hi ? 'हिस्ट्री साफ़ करें' : 'Clear History';
  String get clearAll => _hi ? 'सब हटाएं' : 'Clear all';
  String get deleteEntry => _hi ? 'हटाएं' : 'Delete';

  String get allTools => _hi ? 'सभी टूल्स' : 'All Tools';
  String get searchTools => _hi ? 'टूल खोजें...' : 'Search tools...';

  String get personalizeExperience =>
      _hi ? 'अनुभव को अपने अनुसार बनाएं' : 'Personalize Your Experience';
  String get darkTheme => _hi ? 'डार्क थीम' : 'Dark theme';
  String get colorTheme => _hi ? 'कलर थीम' : 'Color Theme';
  String get language => _hi ? 'भाषा' : 'Language';
  String get thousandsSeparator =>
      _hi ? 'थाउज़ेंड सेपरेटर' : 'Thousands separator';
  String get decimalPlaces => _hi ? 'दशमलव स्थान' : 'Decimal places';
  String get automatic => _hi ? 'स्वचालित' : 'Automatic';
  String get privacyPolicy => _hi ? 'गोपनीयता नीति' : 'Privacy policy';
  String get about => _hi ? 'ऐप के बारे में' : 'About this app';
  String get comingSoon => _hi ? 'जल्द आ रहा है' : 'Coming soon';

  String get scientificFunctions =>
      _hi ? 'वैज्ञानिक फ़ंक्शन' : 'Scientific functions';
  String get error => _hi ? 'त्रुटि' : 'Error';
}
