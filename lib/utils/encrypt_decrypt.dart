/* /* import 'package:encrypt/encrypt.dart';

class AesEncryption {
  String strPwd = 'Ube7FaGz0Vr8H3HBgwXSQ+DDnMdbXvYCEnr7nx4cq1Q=';
  String strIv = 'KWgk9bSS3nR3ad3j3zXUMA==';

  String encrypt(String plainText) {
    final key = Key.fromUtf8(strPwd.substring(0, strPwd.length).trim());
    final iv = IV.fromUtf8(strIv.substring(0, 16));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

// Decrypt data
  String decrypt(String encryptedData) {
    final key = Key.fromUtf8(strPwd.substring(0, strPwd.length).trim());
    final iv = IV.fromUtf8(strIv.substring(0, 16));
    final decrypter = Encrypter(AES(key, padding: 'PKCS7'));
    // final enc64 = Encrypted.fromBase64(encryptedData);
    return decrypter.decrypt64(encryptedData, iv: iv);
  }
}
 */
import 'package:encrypt/encrypt.dart' as encrypt;

class AesEncription {
  String encryptionKey = 'Ube7FaGz0Vr8H3HBgwXSQ+DDnMdbXvYCEnr7nx4cq1Q=';
  String encryptionIV = 'KWgk9bSS3nR3ad3j3zXUMA==';
  String encryption(String plainText) {
    /* final key =
        encrypt.Key.fromUtf8(ENCRYPTION_KEY.toString().substring(0, 16));
    final iv = encrypt.IV.fromUtf8(ENCRYPTION_IV.toString().substring(0, 16)); */

    final key = encrypt.Key.fromBase64(encryptionKey);
    final iv = encrypt.IV.fromBase64(encryptionIV);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryption(String encryptedText) {
    final key = encrypt.Key.fromBase64(encryptionKey);
    final iv = encrypt.IV.fromBase64(encryptionIV);

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);

    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
 */