import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../models/storage_file_model.dart';

class FirebaseStorageService {
  FirebaseStorageService({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<StorageFileModel> uploadFile({
    required File file,
    required String folder,
    String? customFileName,
    SettableMetadata? metadata,
  }) async {
    final String fileName = customFileName ?? path.basename(file.path);
    final String fullPath = '$folder/$fileName';

    final Reference ref = _storage.ref().child(fullPath);

    final UploadTask uploadTask = ref.putFile(file, metadata);
    final TaskSnapshot snapshot = await uploadTask;

    final String downloadUrl = await snapshot.ref.getDownloadURL();
    final FullMetadata fullMetadata = await snapshot.ref.getMetadata();

    return StorageFileModel(
      name: fileName,
      fullPath: fullPath,
      downloadUrl: downloadUrl,
      contentType: fullMetadata.contentType,
      size: fullMetadata.size,
      createdAt: fullMetadata.timeCreated,
    );
  }

  Future<String> uploadBytes({
    required Uint8List bytes,
    required String folder,
    required String fileName,
    SettableMetadata? metadata,
  }) async {
    final String fullPath = '$folder/$fileName';
    final Reference ref = _storage.ref().child(fullPath);

    final UploadTask uploadTask = ref.putData(bytes, metadata);
    await uploadTask;

    return ref.getDownloadURL();
  }

  Future<String> getDownloadUrl(String fullPath) async {
    return _storage.ref().child(fullPath).getDownloadURL();
  }

  Future<FullMetadata> getMetadata(String fullPath) async {
    return _storage.ref().child(fullPath).getMetadata();
  }

  Future<void> deleteFile(String fullPath) async {
    await _storage.ref().child(fullPath).delete();
  }

  Future<List<StorageFileModel>> listFiles(String folder) async {
    final ListResult result = await _storage.ref().child(folder).listAll();

    final List<StorageFileModel> files = [];

    for (final item in result.items) {
      final String downloadUrl = await item.getDownloadURL();
      final FullMetadata metadata = await item.getMetadata();

      files.add(
        StorageFileModel(
          name: item.name,
          fullPath: item.fullPath,
          downloadUrl: downloadUrl,
          contentType: metadata.contentType,
          size: metadata.size,
          createdAt: metadata.timeCreated,
        ),
      );
    }

    return files;
  }
}
