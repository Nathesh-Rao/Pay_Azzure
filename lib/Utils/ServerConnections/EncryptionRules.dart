/*

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pointycastle/export.dart';

class Aes {
  static String encryptString(String key) {
    // Generate a random 16-byte initialization vector (IV)
    var dt = DateTime.now();
    var plainText = "Debasish"; //DateFormat('yyyyMMddHHmmss').format(dt);
    final secureRandom = Random.secure();
    final iv = Uint8List.fromList(List<int>.generate(16, (_) => secureRandom.nextInt(256)));

    // Create key parameter
    final keyParam = KeyParameter(Uint8List.fromList(Encoding.getByName("utf-8")!.encode(key)));
    // Create an AES engine
    final params = ParametersWithIV(keyParam, iv); // Consider using a more secure mode like GCM

    // Initialize the cipher for encryption
    final engine = new AESEngine();

    final cipher = new CTRStreamCipher(engine);
    cipher.init(true, params);

    // Encrypt the plain text
    final encryptedBytes = cipher.process(Uint8List.fromList(Encoding.getByName("utf-8")!.encode(plainText)));

    // Combine IV and encrypted data
    final combinedData = Uint8List.fromList(iv + encryptedBytes);

    // Return Base64 encoded string
    return base64Encode(combinedData);
  }

  static String decryptString(String cipherText, String key) {
    // Decode Base64 string
    final combinedData = base64Decode(cipherText);

    // Extract IV (assuming first 16 bytes)
    final iv = combinedData.sublist(0, 16);

    // Extract encrypted data
    final encryptedBytes = combinedData.sublist(16);
    final keyParam = KeyParameter(Uint8List.fromList(Encoding.getByName("utf-8")!.encode(key)));

    // Create parameters with IV
    final params = ParametersWithIV(keyParam, iv); // Consider using the same mode as encryption

    // Create key parameter

    // Initialize the cipher for decryption
    final engine = new AESEngine();

    final cipher = new CTRStreamCipher(engine);
    cipher.init(true, params);

    // Dec  rypt the data
    final decryptedBytes = cipher.process(encryptedBytes);

    // Return decrypted string
    return utf8.decode(decryptedBytes);
  }
}
 */

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:intl/intl.dart';

class Aes {
  encryptString(String keyValue) {
    final plainText = '20240513131518';
    print("Key value:${keyValue}");
    final key = Key.fromUtf8(keyValue);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cfb64));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print("Enc: ${encrypted.base64}");
    // decryptString(encrypted.base64, keyValue);
  }

  decryptString(String cipherText, String keyValue) {
    final key = Key.fromUtf8(keyValue);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cfb64, padding: null));
    final decrypted = encrypter.decrypt64(cipherText, iv: iv);

    // final Uint8List encryptedBytesWithSalt = base64.decode(cipherText);
    // final Uint8List encryptedBytes = encryptedBytesWithSalt.sublist(
    //   0,
    //   encryptedBytesWithSalt.length,
    // );
    // final String decrypted = encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
    // // return decrypted;
    print("Decrypted value: ${decrypted}");
  }
}
