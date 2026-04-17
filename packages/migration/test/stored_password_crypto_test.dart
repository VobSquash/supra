import 'package:migration/src/auth/plaintext_from_profile_password.dart';
import 'package:test/test.dart';

void main() {
  const sampleDbPassword =
      'KHnKrakXG9IWlF3gpD5/Zw==:XKawnTuGkLhzeK4cfAFopXGyCYirHIJupljSEwaohoJ6dlGtL3Mi+fqFxDZI2WYc';
  const sampleEnglish = 'Lorem Ipsom Stylish Styles';

  test('plaintextPasswordFromProfileField matches legacy example blob', () {
    expect(
      plaintextPasswordFromProfileField(sampleDbPassword),
      sampleEnglish,
    );
  });
}
