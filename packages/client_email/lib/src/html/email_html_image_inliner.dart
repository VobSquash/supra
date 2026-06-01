import 'dart:convert';

/// Inlines or rewrites remote image URLs in HTML email templates.
abstract final class EmailHtmlImageInliner {
  EmailHtmlImageInliner._();

  /// Rewrites known legacy [sourceUrl] values to `[baseUrl]/[filename]`.
  static String rewriteMappedUrls({
    required String html,
    required String baseUrl,
    required Map<String, String> sourceUrlToFilename,
  }) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    var result = html;
    for (final entry in sourceUrlToFilename.entries) {
      if (!result.contains(entry.key)) continue;
      result = result.replaceAll(entry.key, '$normalizedBase${entry.value}');
    }
    return result;
  }

  /// Replaces exact [sourceUrl] occurrences in [html] with a `data:` URI.
  static String inlineKnownUrls({
    required String html,
    required Map<String, EmailInlineImage> imageBySourceUrl,
  }) {
    var result = html;
    for (final entry in imageBySourceUrl.entries) {
      final dataUri = entry.value.dataUri;
      if (dataUri == null) continue;
      if (!result.contains(entry.key)) continue;
      result = result.replaceAll(entry.key, dataUri);
    }
    return result;
  }

  /// Rewrites legacy `api.vobsquash.co.za/.../filename.png` (and similar) to
  /// `[baseUrl]/filename.png` for a public bucket/CDN.
  static String rewriteToPublicAssetBase({
    required String html,
    required String baseUrl,
  }) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final pattern = RegExp(
      r'''https?://[^"'\s>]+/([\w\-\.]+\.(?:png|jpg|jpeg|gif|webp))''',
      caseSensitive: false,
    );

    return html.replaceAllMapped(pattern, (match) {
      final file = match.group(1);
      if (file == null || file.isEmpty) return match.group(0)!;
      final original = match.group(0)!;
      if (original.startsWith('data:')) return original;
      // Already rewritten to the configured bucket — do not touch again.
      if (original.startsWith(normalizedBase)) return original;
      return '$normalizedBase$file';
    });
  }

  /// Replaces [bucketBaseUrl] image URLs in [html] with `data:` URIs from [bytesByUrl].
  static String inlineBucketUrls({
    required String html,
    required String bucketBaseUrl,
    required Map<String, EmailInlineImage> bytesByUrl,
  }) {
    final normalizedBase = bucketBaseUrl.endsWith('/') ? bucketBaseUrl : '$bucketBaseUrl/';
    var result = html;
    for (final entry in bytesByUrl.entries) {
      final dataUri = entry.value.dataUri;
      if (dataUri == null) continue;
      final url = entry.key.startsWith('http') ? entry.key : '$normalizedBase${entry.key}';
      if (result.contains(url)) {
        result = result.replaceAll(url, dataUri);
      }
    }
    return result;
  }

  /// Collects absolute image URLs under [bucketBaseUrl] from [html].
  static Set<String> bucketImageUrlsInHtml({
    required String html,
    required String bucketBaseUrl,
  }) {
    final normalizedBase = bucketBaseUrl.endsWith('/') ? bucketBaseUrl : '$bucketBaseUrl/';
    final escaped = RegExp.escape(normalizedBase);
    final pattern = RegExp(
      '$escaped([\\w\\-\\.]+\\.(?:png|jpg|jpeg|gif|webp))',
      caseSensitive: false,
    );
    return pattern.allMatches(html).map((m) => m.group(0)!).toSet();
  }
}

/// Binary image ready to embed as `data:image/...;base64,...`.
class EmailInlineImage {
  const EmailInlineImage({required this.bytes, required this.mimeType});

  final List<int> bytes;
  final String mimeType;

  String? get dataUri {
    if (bytes.isEmpty) return null;
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }

  static String mimeFromPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'application/octet-stream';
  }
}
