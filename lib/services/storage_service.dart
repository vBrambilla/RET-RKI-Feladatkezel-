import '../models/attachment.dart';

class StorageService {
  Future<Attachment> uploadFile(String userId, String filename) async {
    // Mock implementáció: valódi fájlfeltöltés helyett csak egy Attachment objektumot adunk vissza
    return Attachment(
      filename: filename,
      uploadedBy: userId,
      uploadedAt: DateTime.now(),
    );
  }

  Future<void> deleteFile(String filename) async {
    // Mock implementáció: üres, mert nem tárolunk valódi fájlokat
  }
}
