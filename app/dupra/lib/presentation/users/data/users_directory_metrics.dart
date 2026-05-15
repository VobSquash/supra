/// Geometry for profile directory lists + scroll-letter math (must stay in sync everywhere).
abstract final class UsersDirectoryRowMetrics {
  static const double listPaddingTop = 4;
  static const double listPaddingBottom = 24;

  static const double separatorHeight = 10;

  /// Fixed tile slot — tall enough for the directory avatar row tile.
  static const double tileHeight = 132;

  /// One scroll stride: avatar row + spacer before the next row.
  static const double rowStride = tileHeight + separatorHeight;
}
