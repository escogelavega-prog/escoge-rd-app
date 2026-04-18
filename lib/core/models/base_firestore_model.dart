import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseFirestoreModel {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseFirestoreModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap();

  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? asStringDynamicMap(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }

    return null;
  }

  static List<Map<String, dynamic>> asMapList(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];

    return value
        .map(asStringDynamicMap)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  static String dateOnlyString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static Map<String, dynamic> withTimestamps({
    required Map<String, dynamic> data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      ...data,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
