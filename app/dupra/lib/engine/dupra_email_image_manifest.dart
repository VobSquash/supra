/// Maps legacy remote `src` URLs in HTML templates to filenames in the public
/// Supabase `email-images` bucket (`email_asset_base_url` + filename).
abstract final class DupraEmailImageManifest {
  DupraEmailImageManifest._();

  /// Legacy template URL → object name in the `email-images` bucket.
  static const Map<String, String> sourceUrlToFilename = {
    // stripio (legacy API — host no longer serves these)
    'https://api.vobsquash.co.za/images/stripio/logo-side.png': 'logo-side.png',
    'https://api.vobsquash.co.za/images/stripio/header.png': 'header.png',
    'https://api.vobsquash.co.za/images/stripio/shirt.png': 'shirt.png',
    'https://api.vobsquash.co.za/images/stripio/it_comms.png': 'it_comms.png',
    'https://api.vobsquash.co.za/images/stripio/facebook-circle-gray.png':
        'facebook-circle-gray.png',
    'https://api.vobsquash.co.za/images/stripio/twitter-circle-gray.png':
        'twitter-circle-gray.png',
    // portal / GitHub raw (general mail)
    'https://raw.githubusercontent.com/VobSquash/portal/refs/heads/main/assets/assets/images/home_light_mode.png':
        'home_light_mode.png',
    'https://raw.githubusercontent.com/VobSquash/portal/main/assets/assets/images/home_light_mode.png':
        'home_light_mode.png',
    'https://raw.githubusercontent.com/VobSquash/portal/refs/heads/main/assets/assets/images/Brent.png':
        'Brent.png',
    'https://raw.githubusercontent.com/VobSquash/portal/main/assets/assets/images/Brent.png':
        'Brent.png',
  };
}
