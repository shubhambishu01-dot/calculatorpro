import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_pro/provider/app_strings.dart';
import 'package:calculator_pro/provider/theme_provider.dart';
import 'package:calculator_pro/custom_widgets/privacy_policy_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDarkMode = theme.isDarkMode;
    final strings = AppStrings(theme.language);
    final bg = isDarkMode ? const Color(0xFF0E0E10) : const Color(0xFFF3F4F6);
    final cardColor = isDarkMode ? const Color(0xFF1A1A1C) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1C1C1E);
    final subColor = isDarkMode ? Colors.white38 : Colors.black38;

    return Container(
      color: bg,
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text(
              strings.settingsTab.toUpperCase(),
              style: TextStyle(
                color: theme.accentColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.personalizeExperience,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w800,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 24),

            // Dark theme toggle
            _SettingsCard(
              cardColor: cardColor,
              children: [
                _SwitchRow(
                  icon: Icons.wb_sunny_outlined,
                  label: strings.darkTheme,
                  value: isDarkMode,
                  activeColor: theme.accentColor,
                  textColor: textColor,
                  onChanged: (v) => theme.setDarkMode(v),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Accent theme picker
            _SettingsCard(
              cardColor: cardColor,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                  child: Row(
                    children: [
                      Icon(Icons.palette_outlined, color: textColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        strings.colorTheme,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ...AppAccent.values.map((accent) {
                  final data = kAccents[accent]!;
                  final selected = theme.accent == accent;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => theme.setAccent(accent),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                selected
                                    ? data.primary
                                    : Colors.transparent,
                            width: 1.4,
                          ),
                          color:
                              selected
                                  ? data.primary.withOpacity(0.08)
                                  : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Text(
                              data.label,
                              style: TextStyle(
                                color: textColor,
                                fontWeight:
                                    selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            _swatch(data.primary),
                            const SizedBox(width: 6),
                            _swatch(data.secondary),
                            const SizedBox(width: 6),
                            _swatch(data.tertiary),
                            if (selected) ...[
                              const SizedBox(width: 10),
                              Icon(
                                Icons.check_circle,
                                color: data.primary,
                                size: 18,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Language
            _SettingsCard(
              cardColor: cardColor,
              children: [
                _DropdownRow<AppLanguage>(
                  icon: Icons.language,
                  label: strings.language,
                  value: theme.language,
                  textColor: textColor,
                  subColor: subColor,
                  items: const {
                    AppLanguage.english: 'English',
                    AppLanguage.hindi: 'हिन्दी',
                  },
                  onChanged: (v) => theme.setLanguage(v!),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Number formatting
            _SettingsCard(
              cardColor: cardColor,
              children: [
                _DropdownRow<String>(
                  icon: Icons.pin_outlined,
                  label: strings.thousandsSeparator,
                  value: theme.thousandsSeparator,
                  textColor: textColor,
                  subColor: subColor,
                  items: const {
                    ',': 'Comma (,)',
                    '.': 'Dot (.)',
                    ' ': 'Space',
                    '': 'None',
                  },
                  onChanged: (v) => theme.setThousandsSeparator(v!),
                ),
                const Divider(height: 24),
                _DropdownRow<int>(
                  icon: Icons.dialpad,
                  label: strings.decimalPlaces,
                  value: theme.decimalPlaces,
                  textColor: textColor,
                  subColor: subColor,
                  items: {
                    -1: strings.automatic,
                    0: '0',
                    1: '1',
                    2: '2',
                    3: '3',
                    4: '4',
                    5: '5',
                    6: '6',
                  },
                  onChanged: (v) => theme.setDecimalPlaces(v!),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _SettingsCard(
              cardColor: cardColor,
              children: [
                _LinkRow(
                  icon: Icons.privacy_tip_outlined,
                  label: strings.privacyPolicy,
                  textColor: textColor,
                  onTap: () => showPrivacyPolicyDialog(context),
                ),
                const Divider(height: 24),
                _LinkRow(
                  icon: Icons.info_outline,
                  label: strings.about,
                  textColor: textColor,
                  trailing: 'v1.0.0',
                  subColor: subColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _swatch(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Color cardColor;
  final List<Widget> children;
  const _SettingsCard({required this.cardColor, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final Color activeColor;
  final Color textColor;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.activeColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: textColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(value: value, activeColor: activeColor, onChanged: onChanged),
      ],
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final IconData icon;
  final String label;
  final T value;
  final Map<T, String> items;
  final Color textColor;
  final Color subColor;
  final ValueChanged<T?> onChanged;

  const _DropdownRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.textColor,
    required this.subColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: textColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropdownButton<T>(
          value: value,
          underline: const SizedBox.shrink(),
          dropdownColor:
              textColor == Colors.white
                  ? const Color(0xFF1A1A1C)
                  : Colors.white,
          style: TextStyle(color: subColor, fontWeight: FontWeight.w600),
          items:
              items.entries
                  .map(
                    (e) =>
                        DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final String? trailing;
  final Color? subColor;
  final VoidCallback? onTap;

  const _LinkRow({
    required this.icon,
    required this.label,
    required this.textColor,
    this.trailing,
    this.subColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ),
            if (trailing != null)
              Text(trailing!, style: TextStyle(color: subColor, fontSize: 13)),
            if (trailing == null)
              Icon(
                Icons.chevron_right,
                color: subColor ?? Colors.grey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
