import 'dart:convert';

enum TextSizeOption { normal, large, extraLarge }

class AccessibilitySettings {
  const AccessibilitySettings({
    this.textSize = TextSizeOption.normal,
    this.colorBlind = false,
  });

  final TextSizeOption textSize;
  final bool colorBlind;

  double get textScale => switch (textSize) {
        TextSizeOption.normal => 1.0,
        TextSizeOption.large => 1.18,
        TextSizeOption.extraLarge => 1.38,
      };

  AccessibilitySettings copyWith({
    TextSizeOption? textSize,
    bool? colorBlind,
  }) =>
      AccessibilitySettings(
        textSize: textSize ?? this.textSize,
        colorBlind: colorBlind ?? this.colorBlind,
      );

  Map<String, dynamic> toJson() => {
        'textSize': textSize.name,
        'colorBlind': colorBlind,
      };

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) =>
      AccessibilitySettings(
        textSize: TextSizeOption.values.firstWhere(
          (e) => e.name == json['textSize'],
          orElse: () => TextSizeOption.normal,
        ),
        colorBlind: json['colorBlind'] as bool? ?? false,
      );

  factory AccessibilitySettings.fromJsonString(String? s) {
    if (s == null) return const AccessibilitySettings();
    try {
      return AccessibilitySettings.fromJson(
          jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return const AccessibilitySettings();
    }
  }
}
