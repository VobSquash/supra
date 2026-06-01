// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EmailEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailEventCopyWith<$Res> {
  factory $EmailEventCopyWith(
    EmailEvent value,
    $Res Function(EmailEvent) then,
  ) = _$EmailEventCopyWithImpl<$Res, EmailEvent>;
}

/// @nodoc
class _$EmailEventCopyWithImpl<$Res, $Val extends EmailEvent>
    implements $EmailEventCopyWith<$Res> {
  _$EmailEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OnUpdateBodyImplCopyWith<$Res> {
  factory _$$OnUpdateBodyImplCopyWith(
    _$OnUpdateBodyImpl value,
    $Res Function(_$OnUpdateBodyImpl) then,
  ) = __$$OnUpdateBodyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String body});
}

/// @nodoc
class __$$OnUpdateBodyImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnUpdateBodyImpl>
    implements _$$OnUpdateBodyImplCopyWith<$Res> {
  __$$OnUpdateBodyImplCopyWithImpl(
    _$OnUpdateBodyImpl _value,
    $Res Function(_$OnUpdateBodyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? body = null}) {
    return _then(
      _$OnUpdateBodyImpl(
        null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OnUpdateBodyImpl implements OnUpdateBody {
  const _$OnUpdateBodyImpl(this.body);

  @override
  final String body;

  @override
  String toString() {
    return 'EmailEvent.onUpdateBody(body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnUpdateBodyImpl &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, body);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnUpdateBodyImplCopyWith<_$OnUpdateBodyImpl> get copyWith =>
      __$$OnUpdateBodyImplCopyWithImpl<_$OnUpdateBodyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onUpdateBody(body);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onUpdateBody?.call(body);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onUpdateBody != null) {
      return onUpdateBody(body);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onUpdateBody(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onUpdateBody?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onUpdateBody != null) {
      return onUpdateBody(this);
    }
    return orElse();
  }
}

abstract class OnUpdateBody implements EmailEvent {
  const factory OnUpdateBody(final String body) = _$OnUpdateBodyImpl;

  String get body;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnUpdateBodyImplCopyWith<_$OnUpdateBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnUpdateSubjectImplCopyWith<$Res> {
  factory _$$OnUpdateSubjectImplCopyWith(
    _$OnUpdateSubjectImpl value,
    $Res Function(_$OnUpdateSubjectImpl) then,
  ) = __$$OnUpdateSubjectImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String subject});
}

/// @nodoc
class __$$OnUpdateSubjectImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnUpdateSubjectImpl>
    implements _$$OnUpdateSubjectImplCopyWith<$Res> {
  __$$OnUpdateSubjectImplCopyWithImpl(
    _$OnUpdateSubjectImpl _value,
    $Res Function(_$OnUpdateSubjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? subject = null}) {
    return _then(
      _$OnUpdateSubjectImpl(
        null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OnUpdateSubjectImpl implements OnUpdateSubject {
  const _$OnUpdateSubjectImpl(this.subject);

  @override
  final String subject;

  @override
  String toString() {
    return 'EmailEvent.onUpdateSubject(subject: $subject)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnUpdateSubjectImpl &&
            (identical(other.subject, subject) || other.subject == subject));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subject);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnUpdateSubjectImplCopyWith<_$OnUpdateSubjectImpl> get copyWith =>
      __$$OnUpdateSubjectImplCopyWithImpl<_$OnUpdateSubjectImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onUpdateSubject(subject);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onUpdateSubject?.call(subject);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onUpdateSubject != null) {
      return onUpdateSubject(subject);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onUpdateSubject(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onUpdateSubject?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onUpdateSubject != null) {
      return onUpdateSubject(this);
    }
    return orElse();
  }
}

abstract class OnUpdateSubject implements EmailEvent {
  const factory OnUpdateSubject(final String subject) = _$OnUpdateSubjectImpl;

  String get subject;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnUpdateSubjectImplCopyWith<_$OnUpdateSubjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnSendTestMailerImplCopyWith<$Res> {
  factory _$$OnSendTestMailerImplCopyWith(
    _$OnSendTestMailerImpl value,
    $Res Function(_$OnSendTestMailerImpl) then,
  ) = __$$OnSendTestMailerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String testRecipientEmail});
}

/// @nodoc
class __$$OnSendTestMailerImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnSendTestMailerImpl>
    implements _$$OnSendTestMailerImplCopyWith<$Res> {
  __$$OnSendTestMailerImplCopyWithImpl(
    _$OnSendTestMailerImpl _value,
    $Res Function(_$OnSendTestMailerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? testRecipientEmail = null}) {
    return _then(
      _$OnSendTestMailerImpl(
        testRecipientEmail: null == testRecipientEmail
            ? _value.testRecipientEmail
            : testRecipientEmail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OnSendTestMailerImpl implements OnSendTestMailer {
  const _$OnSendTestMailerImpl({required this.testRecipientEmail});

  @override
  final String testRecipientEmail;

  @override
  String toString() {
    return 'EmailEvent.onSendTestMailer(testRecipientEmail: $testRecipientEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnSendTestMailerImpl &&
            (identical(other.testRecipientEmail, testRecipientEmail) ||
                other.testRecipientEmail == testRecipientEmail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, testRecipientEmail);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnSendTestMailerImplCopyWith<_$OnSendTestMailerImpl> get copyWith =>
      __$$OnSendTestMailerImplCopyWithImpl<_$OnSendTestMailerImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onSendTestMailer(testRecipientEmail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onSendTestMailer?.call(testRecipientEmail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendTestMailer != null) {
      return onSendTestMailer(testRecipientEmail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onSendTestMailer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onSendTestMailer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendTestMailer != null) {
      return onSendTestMailer(this);
    }
    return orElse();
  }
}

abstract class OnSendTestMailer implements EmailEvent {
  const factory OnSendTestMailer({required final String testRecipientEmail}) =
      _$OnSendTestMailerImpl;

  String get testRecipientEmail;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnSendTestMailerImplCopyWith<_$OnSendTestMailerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnSendGeneralMailerImplCopyWith<$Res> {
  factory _$$OnSendGeneralMailerImplCopyWith(
    _$OnSendGeneralMailerImpl value,
    $Res Function(_$OnSendGeneralMailerImpl) then,
  ) = __$$OnSendGeneralMailerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int minimumRecipientCount});
}

/// @nodoc
class __$$OnSendGeneralMailerImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnSendGeneralMailerImpl>
    implements _$$OnSendGeneralMailerImplCopyWith<$Res> {
  __$$OnSendGeneralMailerImplCopyWithImpl(
    _$OnSendGeneralMailerImpl _value,
    $Res Function(_$OnSendGeneralMailerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? minimumRecipientCount = null}) {
    return _then(
      _$OnSendGeneralMailerImpl(
        minimumRecipientCount: null == minimumRecipientCount
            ? _value.minimumRecipientCount
            : minimumRecipientCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$OnSendGeneralMailerImpl implements OnSendGeneralMailer {
  const _$OnSendGeneralMailerImpl({this.minimumRecipientCount = 10});

  @override
  @JsonKey()
  final int minimumRecipientCount;

  @override
  String toString() {
    return 'EmailEvent.onSendGeneralMailer(minimumRecipientCount: $minimumRecipientCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnSendGeneralMailerImpl &&
            (identical(other.minimumRecipientCount, minimumRecipientCount) ||
                other.minimumRecipientCount == minimumRecipientCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minimumRecipientCount);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnSendGeneralMailerImplCopyWith<_$OnSendGeneralMailerImpl> get copyWith =>
      __$$OnSendGeneralMailerImplCopyWithImpl<_$OnSendGeneralMailerImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onSendGeneralMailer(minimumRecipientCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onSendGeneralMailer?.call(minimumRecipientCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendGeneralMailer != null) {
      return onSendGeneralMailer(minimumRecipientCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onSendGeneralMailer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onSendGeneralMailer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendGeneralMailer != null) {
      return onSendGeneralMailer(this);
    }
    return orElse();
  }
}

abstract class OnSendGeneralMailer implements EmailEvent {
  const factory OnSendGeneralMailer({final int minimumRecipientCount}) =
      _$OnSendGeneralMailerImpl;

  int get minimumRecipientCount;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnSendGeneralMailerImplCopyWith<_$OnSendGeneralMailerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnSendBookingTestMailerImplCopyWith<$Res> {
  factory _$$OnSendBookingTestMailerImplCopyWith(
    _$OnSendBookingTestMailerImpl value,
    $Res Function(_$OnSendBookingTestMailerImpl) then,
  ) = __$$OnSendBookingTestMailerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String testRecipientEmail, String displayName});
}

/// @nodoc
class __$$OnSendBookingTestMailerImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnSendBookingTestMailerImpl>
    implements _$$OnSendBookingTestMailerImplCopyWith<$Res> {
  __$$OnSendBookingTestMailerImplCopyWithImpl(
    _$OnSendBookingTestMailerImpl _value,
    $Res Function(_$OnSendBookingTestMailerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? testRecipientEmail = null, Object? displayName = null}) {
    return _then(
      _$OnSendBookingTestMailerImpl(
        testRecipientEmail: null == testRecipientEmail
            ? _value.testRecipientEmail
            : testRecipientEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OnSendBookingTestMailerImpl implements OnSendBookingTestMailer {
  const _$OnSendBookingTestMailerImpl({
    required this.testRecipientEmail,
    required this.displayName,
  });

  @override
  final String testRecipientEmail;
  @override
  final String displayName;

  @override
  String toString() {
    return 'EmailEvent.onSendBookingTestMailer(testRecipientEmail: $testRecipientEmail, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnSendBookingTestMailerImpl &&
            (identical(other.testRecipientEmail, testRecipientEmail) ||
                other.testRecipientEmail == testRecipientEmail) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, testRecipientEmail, displayName);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnSendBookingTestMailerImplCopyWith<_$OnSendBookingTestMailerImpl>
  get copyWith =>
      __$$OnSendBookingTestMailerImplCopyWithImpl<
        _$OnSendBookingTestMailerImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onSendBookingTestMailer(testRecipientEmail, displayName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onSendBookingTestMailer?.call(testRecipientEmail, displayName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendBookingTestMailer != null) {
      return onSendBookingTestMailer(testRecipientEmail, displayName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onSendBookingTestMailer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onSendBookingTestMailer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendBookingTestMailer != null) {
      return onSendBookingTestMailer(this);
    }
    return orElse();
  }
}

abstract class OnSendBookingTestMailer implements EmailEvent {
  const factory OnSendBookingTestMailer({
    required final String testRecipientEmail,
    required final String displayName,
  }) = _$OnSendBookingTestMailerImpl;

  String get testRecipientEmail;
  String get displayName;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnSendBookingTestMailerImplCopyWith<_$OnSendBookingTestMailerImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnSendWelcomeEmailImplCopyWith<$Res> {
  factory _$$OnSendWelcomeEmailImplCopyWith(
    _$OnSendWelcomeEmailImpl value,
    $Res Function(_$OnSendWelcomeEmailImpl) then,
  ) = __$$OnSendWelcomeEmailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String? welcomePdfPath});
}

/// @nodoc
class __$$OnSendWelcomeEmailImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnSendWelcomeEmailImpl>
    implements _$$OnSendWelcomeEmailImplCopyWith<$Res> {
  __$$OnSendWelcomeEmailImplCopyWithImpl(
    _$OnSendWelcomeEmailImpl _value,
    $Res Function(_$OnSendWelcomeEmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? welcomePdfPath = freezed}) {
    return _then(
      _$OnSendWelcomeEmailImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        welcomePdfPath: freezed == welcomePdfPath
            ? _value.welcomePdfPath
            : welcomePdfPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OnSendWelcomeEmailImpl implements OnSendWelcomeEmail {
  const _$OnSendWelcomeEmailImpl({required this.email, this.welcomePdfPath});

  @override
  final String email;
  @override
  final String? welcomePdfPath;

  @override
  String toString() {
    return 'EmailEvent.onSendWelcomeEmail(email: $email, welcomePdfPath: $welcomePdfPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnSendWelcomeEmailImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.welcomePdfPath, welcomePdfPath) ||
                other.welcomePdfPath == welcomePdfPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, welcomePdfPath);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnSendWelcomeEmailImplCopyWith<_$OnSendWelcomeEmailImpl> get copyWith =>
      __$$OnSendWelcomeEmailImplCopyWithImpl<_$OnSendWelcomeEmailImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onSendWelcomeEmail(email, welcomePdfPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onSendWelcomeEmail?.call(email, welcomePdfPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendWelcomeEmail != null) {
      return onSendWelcomeEmail(email, welcomePdfPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onSendWelcomeEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onSendWelcomeEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendWelcomeEmail != null) {
      return onSendWelcomeEmail(this);
    }
    return orElse();
  }
}

abstract class OnSendWelcomeEmail implements EmailEvent {
  const factory OnSendWelcomeEmail({
    required final String email,
    final String? welcomePdfPath,
  }) = _$OnSendWelcomeEmailImpl;

  String get email;
  String? get welcomePdfPath;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnSendWelcomeEmailImplCopyWith<_$OnSendWelcomeEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnSendFeesEmailImplCopyWith<$Res> {
  factory _$$OnSendFeesEmailImplCopyWith(
    _$OnSendFeesEmailImpl value,
    $Res Function(_$OnSendFeesEmailImpl) then,
  ) = __$$OnSendFeesEmailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String recipientEmail, String? feesPdfPath});
}

/// @nodoc
class __$$OnSendFeesEmailImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnSendFeesEmailImpl>
    implements _$$OnSendFeesEmailImplCopyWith<$Res> {
  __$$OnSendFeesEmailImplCopyWithImpl(
    _$OnSendFeesEmailImpl _value,
    $Res Function(_$OnSendFeesEmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? recipientEmail = null, Object? feesPdfPath = freezed}) {
    return _then(
      _$OnSendFeesEmailImpl(
        recipientEmail: null == recipientEmail
            ? _value.recipientEmail
            : recipientEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        feesPdfPath: freezed == feesPdfPath
            ? _value.feesPdfPath
            : feesPdfPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OnSendFeesEmailImpl implements OnSendFeesEmail {
  const _$OnSendFeesEmailImpl({required this.recipientEmail, this.feesPdfPath});

  @override
  final String recipientEmail;
  @override
  final String? feesPdfPath;

  @override
  String toString() {
    return 'EmailEvent.onSendFeesEmail(recipientEmail: $recipientEmail, feesPdfPath: $feesPdfPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnSendFeesEmailImpl &&
            (identical(other.recipientEmail, recipientEmail) ||
                other.recipientEmail == recipientEmail) &&
            (identical(other.feesPdfPath, feesPdfPath) ||
                other.feesPdfPath == feesPdfPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, recipientEmail, feesPdfPath);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnSendFeesEmailImplCopyWith<_$OnSendFeesEmailImpl> get copyWith =>
      __$$OnSendFeesEmailImplCopyWithImpl<_$OnSendFeesEmailImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onSendFeesEmail(recipientEmail, feesPdfPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onSendFeesEmail?.call(recipientEmail, feesPdfPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendFeesEmail != null) {
      return onSendFeesEmail(recipientEmail, feesPdfPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onSendFeesEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onSendFeesEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendFeesEmail != null) {
      return onSendFeesEmail(this);
    }
    return orElse();
  }
}

abstract class OnSendFeesEmail implements EmailEvent {
  const factory OnSendFeesEmail({
    required final String recipientEmail,
    final String? feesPdfPath,
  }) = _$OnSendFeesEmailImpl;

  String get recipientEmail;
  String? get feesPdfPath;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnSendFeesEmailImplCopyWith<_$OnSendFeesEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnSendChallengeTestMailerImplCopyWith<$Res> {
  factory _$$OnSendChallengeTestMailerImplCopyWith(
    _$OnSendChallengeTestMailerImpl value,
    $Res Function(_$OnSendChallengeTestMailerImpl) then,
  ) = __$$OnSendChallengeTestMailerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String challengedEmail,
    String challengedDisplayName,
    String challengerDisplayName,
    String challengerEmail,
  });
}

/// @nodoc
class __$$OnSendChallengeTestMailerImplCopyWithImpl<$Res>
    extends _$EmailEventCopyWithImpl<$Res, _$OnSendChallengeTestMailerImpl>
    implements _$$OnSendChallengeTestMailerImplCopyWith<$Res> {
  __$$OnSendChallengeTestMailerImplCopyWithImpl(
    _$OnSendChallengeTestMailerImpl _value,
    $Res Function(_$OnSendChallengeTestMailerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? challengedEmail = null,
    Object? challengedDisplayName = null,
    Object? challengerDisplayName = null,
    Object? challengerEmail = null,
  }) {
    return _then(
      _$OnSendChallengeTestMailerImpl(
        challengedEmail: null == challengedEmail
            ? _value.challengedEmail
            : challengedEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        challengedDisplayName: null == challengedDisplayName
            ? _value.challengedDisplayName
            : challengedDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        challengerDisplayName: null == challengerDisplayName
            ? _value.challengerDisplayName
            : challengerDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        challengerEmail: null == challengerEmail
            ? _value.challengerEmail
            : challengerEmail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OnSendChallengeTestMailerImpl implements OnSendChallengeTestMailer {
  const _$OnSendChallengeTestMailerImpl({
    required this.challengedEmail,
    required this.challengedDisplayName,
    required this.challengerDisplayName,
    required this.challengerEmail,
  });

  @override
  final String challengedEmail;
  @override
  final String challengedDisplayName;
  @override
  final String challengerDisplayName;
  @override
  final String challengerEmail;

  @override
  String toString() {
    return 'EmailEvent.onSendChallengeTestMailer(challengedEmail: $challengedEmail, challengedDisplayName: $challengedDisplayName, challengerDisplayName: $challengerDisplayName, challengerEmail: $challengerEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnSendChallengeTestMailerImpl &&
            (identical(other.challengedEmail, challengedEmail) ||
                other.challengedEmail == challengedEmail) &&
            (identical(other.challengedDisplayName, challengedDisplayName) ||
                other.challengedDisplayName == challengedDisplayName) &&
            (identical(other.challengerDisplayName, challengerDisplayName) ||
                other.challengerDisplayName == challengerDisplayName) &&
            (identical(other.challengerEmail, challengerEmail) ||
                other.challengerEmail == challengerEmail));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    challengedEmail,
    challengedDisplayName,
    challengerDisplayName,
    challengerEmail,
  );

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnSendChallengeTestMailerImplCopyWith<_$OnSendChallengeTestMailerImpl>
  get copyWith =>
      __$$OnSendChallengeTestMailerImplCopyWithImpl<
        _$OnSendChallengeTestMailerImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String body) onUpdateBody,
    required TResult Function(String subject) onUpdateSubject,
    required TResult Function(String testRecipientEmail) onSendTestMailer,
    required TResult Function(int minimumRecipientCount) onSendGeneralMailer,
    required TResult Function(String testRecipientEmail, String displayName)
    onSendBookingTestMailer,
    required TResult Function(String email, String? welcomePdfPath)
    onSendWelcomeEmail,
    required TResult Function(String recipientEmail, String? feesPdfPath)
    onSendFeesEmail,
    required TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )
    onSendChallengeTestMailer,
  }) {
    return onSendChallengeTestMailer(
      challengedEmail,
      challengedDisplayName,
      challengerDisplayName,
      challengerEmail,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String body)? onUpdateBody,
    TResult? Function(String subject)? onUpdateSubject,
    TResult? Function(String testRecipientEmail)? onSendTestMailer,
    TResult? Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult? Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult? Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult? Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult? Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
  }) {
    return onSendChallengeTestMailer?.call(
      challengedEmail,
      challengedDisplayName,
      challengerDisplayName,
      challengerEmail,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String body)? onUpdateBody,
    TResult Function(String subject)? onUpdateSubject,
    TResult Function(String testRecipientEmail)? onSendTestMailer,
    TResult Function(int minimumRecipientCount)? onSendGeneralMailer,
    TResult Function(String testRecipientEmail, String displayName)?
    onSendBookingTestMailer,
    TResult Function(String email, String? welcomePdfPath)? onSendWelcomeEmail,
    TResult Function(String recipientEmail, String? feesPdfPath)?
    onSendFeesEmail,
    TResult Function(
      String challengedEmail,
      String challengedDisplayName,
      String challengerDisplayName,
      String challengerEmail,
    )?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendChallengeTestMailer != null) {
      return onSendChallengeTestMailer(
        challengedEmail,
        challengedDisplayName,
        challengerDisplayName,
        challengerEmail,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnUpdateBody value) onUpdateBody,
    required TResult Function(OnUpdateSubject value) onUpdateSubject,
    required TResult Function(OnSendTestMailer value) onSendTestMailer,
    required TResult Function(OnSendGeneralMailer value) onSendGeneralMailer,
    required TResult Function(OnSendBookingTestMailer value)
    onSendBookingTestMailer,
    required TResult Function(OnSendWelcomeEmail value) onSendWelcomeEmail,
    required TResult Function(OnSendFeesEmail value) onSendFeesEmail,
    required TResult Function(OnSendChallengeTestMailer value)
    onSendChallengeTestMailer,
  }) {
    return onSendChallengeTestMailer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnUpdateBody value)? onUpdateBody,
    TResult? Function(OnUpdateSubject value)? onUpdateSubject,
    TResult? Function(OnSendTestMailer value)? onSendTestMailer,
    TResult? Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult? Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult? Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult? Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult? Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
  }) {
    return onSendChallengeTestMailer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnUpdateBody value)? onUpdateBody,
    TResult Function(OnUpdateSubject value)? onUpdateSubject,
    TResult Function(OnSendTestMailer value)? onSendTestMailer,
    TResult Function(OnSendGeneralMailer value)? onSendGeneralMailer,
    TResult Function(OnSendBookingTestMailer value)? onSendBookingTestMailer,
    TResult Function(OnSendWelcomeEmail value)? onSendWelcomeEmail,
    TResult Function(OnSendFeesEmail value)? onSendFeesEmail,
    TResult Function(OnSendChallengeTestMailer value)?
    onSendChallengeTestMailer,
    required TResult orElse(),
  }) {
    if (onSendChallengeTestMailer != null) {
      return onSendChallengeTestMailer(this);
    }
    return orElse();
  }
}

abstract class OnSendChallengeTestMailer implements EmailEvent {
  const factory OnSendChallengeTestMailer({
    required final String challengedEmail,
    required final String challengedDisplayName,
    required final String challengerDisplayName,
    required final String challengerEmail,
  }) = _$OnSendChallengeTestMailerImpl;

  String get challengedEmail;
  String get challengedDisplayName;
  String get challengerDisplayName;
  String get challengerEmail;

  /// Create a copy of EmailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnSendChallengeTestMailerImplCopyWith<_$OnSendChallengeTestMailerImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EmailState {
  String get subject => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  BaseLoading get status => throw _privateConstructorUsedError;

  /// Create a copy of EmailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailStateCopyWith<EmailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailStateCopyWith<$Res> {
  factory $EmailStateCopyWith(
    EmailState value,
    $Res Function(EmailState) then,
  ) = _$EmailStateCopyWithImpl<$Res, EmailState>;
  @useResult
  $Res call({String subject, String body, BaseLoading status});

  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class _$EmailStateCopyWithImpl<$Res, $Val extends EmailState>
    implements $EmailStateCopyWith<$Res> {
  _$EmailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subject = null,
    Object? body = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseLoading,
          )
          as $Val,
    );
  }

  /// Create a copy of EmailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BaseLoadingCopyWith<$Res> get status {
    return $BaseLoadingCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EmailStateImplCopyWith<$Res>
    implements $EmailStateCopyWith<$Res> {
  factory _$$EmailStateImplCopyWith(
    _$EmailStateImpl value,
    $Res Function(_$EmailStateImpl) then,
  ) = __$$EmailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String subject, String body, BaseLoading status});

  @override
  $BaseLoadingCopyWith<$Res> get status;
}

/// @nodoc
class __$$EmailStateImplCopyWithImpl<$Res>
    extends _$EmailStateCopyWithImpl<$Res, _$EmailStateImpl>
    implements _$$EmailStateImplCopyWith<$Res> {
  __$$EmailStateImplCopyWithImpl(
    _$EmailStateImpl _value,
    $Res Function(_$EmailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subject = null,
    Object? body = null,
    Object? status = null,
  }) {
    return _then(
      _$EmailStateImpl(
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseLoading,
      ),
    );
  }
}

/// @nodoc

class _$EmailStateImpl implements _EmailState {
  const _$EmailStateImpl({
    required this.subject,
    required this.body,
    required this.status,
  });

  @override
  final String subject;
  @override
  final String body;
  @override
  final BaseLoading status;

  @override
  String toString() {
    return 'EmailState(subject: $subject, body: $body, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailStateImpl &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subject, body, status);

  /// Create a copy of EmailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailStateImplCopyWith<_$EmailStateImpl> get copyWith =>
      __$$EmailStateImplCopyWithImpl<_$EmailStateImpl>(this, _$identity);
}

abstract class _EmailState implements EmailState {
  const factory _EmailState({
    required final String subject,
    required final String body,
    required final BaseLoading status,
  }) = _$EmailStateImpl;

  @override
  String get subject;
  @override
  String get body;
  @override
  BaseLoading get status;

  /// Create a copy of EmailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailStateImplCopyWith<_$EmailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
