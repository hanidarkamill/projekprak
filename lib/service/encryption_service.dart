import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final key =
      encrypt.Key.fromUtf8('32characterslong32characterslong'); // 32-byte key
  static final iv = encrypt.IV.fromLength(16); // 16-byte initialization vector

  // Enkripsi password
  static String encryptPassword(String password) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  // Dekripsi password
  static String decryptPassword(String encryptedPassword) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  }
}
