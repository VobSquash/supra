// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fees.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeesItemDTOImpl _$$FeesItemDTOImplFromJson(Map<String, dynamic> json) =>
    _$FeesItemDTOImpl(
      cost: (json['Cost'] as num).toDouble(),
      proRataCost: (json['ProRataCost'] as num?)?.toDouble(),
      feeType: json['FeeType'] as String,
    );

Map<String, dynamic> _$$FeesItemDTOImplToJson(_$FeesItemDTOImpl instance) =>
    <String, dynamic>{
      'Cost': instance.cost,
      'ProRataCost': instance.proRataCost,
      'FeeType': instance.feeType,
    };
