import 'package:flutter/widgets.dart';

/// Remix Icon (font) helpers.
///
/// Source of codepoints: `assets/fonts/remixicon.css`
class RemixIcons {
  RemixIcons._();

  static const String _fontFamily = 'RemixIcon';

  /// `.ri-settings-3-line`
  static const IconData settings3Line =
      IconData(0xF0E6, fontFamily: _fontFamily);

  /// `.ri-edit-2-line`
  static const IconData edit2Line = IconData(0xEC80, fontFamily: _fontFamily);

  /// `.ri-user-add-line`
  static const IconData userAddLine = IconData(0xF25E, fontFamily: _fontFamily);
}


