import 'package:encrypt/encrypt.dart';

class EncryptData {
//for AES Algorithms

  static Encrypted? encrypted;
  static var decrypted;

  static encryptAES(plainText) {
    final key = Key.fromUtf8('69703314698391315542979424297148');
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    // print(encrypted!.base64);
    return encrypted!.base64.toString();
  }

  static decryptAES(plainText) {
    final key = Key.fromUtf8('69703314698391315542979424297148');
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key));
    decrypted = encrypter.decrypt64(plainText, iv: iv);

    return decrypted.toString();
  }
}
