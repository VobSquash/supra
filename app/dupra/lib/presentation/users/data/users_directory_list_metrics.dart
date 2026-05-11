part of '../users_page.dart';

/// Geometric constants for directory list + scroll-letter math (must stay in sync).
abstract final class UsersDirectoryRowMetrics {
  static const double listPaddingTop = 4;
  static const double listPaddingBottom = 24;

  static const double separatorHeight = 10;

  /// Fixed tile slot — must fit [_UsersDirectoryTile] (avatar-heavy row).
  static const double tileHeight = 132;

  /// One scroll stride: avatar row + spacer before the next row.
  static const double rowStride = tileHeight + separatorHeight;
}
