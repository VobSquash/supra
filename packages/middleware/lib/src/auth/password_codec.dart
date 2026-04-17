import 'dart:convert';

/// Legacy UI often sends base64-encoded passwords; Supabase Auth expects plain text.
String decodePasswordForSupabaseAuth(String encodedPassword) {
  final trimmed = encodedPassword.trim();
  if (trimmed.isEmpty) return encodedPassword;
  try {
    return utf8.decode(base64.decode(trimmed));
  } catch (_) {
    return encodedPassword;
  }
}
