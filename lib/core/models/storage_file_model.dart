class StorageFileModel {
  final String name;
  final String fullPath;
  final String downloadUrl;
  final String? contentType;
  final int? size;
  final DateTime? createdAt;

  const StorageFileModel({
    required this.name,
    required this.fullPath,
    required this.downloadUrl,
    this.contentType,
    this.size,
    this.createdAt,
  });

  factory StorageFileModel.fromMap(Map<String, dynamic> map) {
    return StorageFileModel(
      name: map['name'] ?? '',
      fullPath: map['fullPath'] ?? '',
      downloadUrl: map['downloadUrl'] ?? '',
      contentType: map['contentType'],
      size: map['size'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fullPath': fullPath,
      'downloadUrl': downloadUrl,
      'contentType': contentType,
      'size': size,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  StorageFileModel copyWith({
    String? name,
    String? fullPath,
    String? downloadUrl,
    String? contentType,
    int? size,
    DateTime? createdAt,
  }) {
    return StorageFileModel(
      name: name ?? this.name,
      fullPath: fullPath ?? this.fullPath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      contentType: contentType ?? this.contentType,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
