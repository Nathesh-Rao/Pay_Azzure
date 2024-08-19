import 'dart:convert';

import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/ServerConnections/EncryptionRules.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';

class ExecuteApi {
  static const String SECRETKEY_HomePage = "1965065173127450";
  static const String API_GET_ENCRYPTED_SECRET_KEY = "api/v1/ARMGetEncryptedSecret";
  static const String API_ARM_EXECUTE = "api/v1/ARMExecuteAPI";
  static const String API_SECRETKEY_GET_PUNCHIN_DATA = "5246994904522510";
  static const String API_SECRETKEY_GET_DO_PUNCHIN = "1408279244140740";
  static const String API_SECRETKEY_GET_DO_PUNCHOUT = "1408279244140740";

  static const String API_PrivateKey_DashBoard = "9511835779821320";
  static const String API_PublicKey_DashBoard = "AXPKEY000000010002";
  static const String API_PrivateKey_Attendance = "1986988291821600";
  static const String API_PublicKey_Attendance = "AXPKEY000000010004";

  // var body;
  var url = Const.getFullARMUrl(API_ARM_EXECUTE);
  // var url = "http://demo.agile-labs.com/arm/" + API_ARM_EXECUTE;

  CallFetchData_ExecuteAPI({body = '', isBearer = false, header = ''}) async {
    var resp = await ServerConnections().postToServer(url: url, header: header, body: body, isBearer: isBearer);
    return resp;
  }

  CallSaveData_ExecuteAPI({body = '', isBearer = false, header = ''}) async {
    var resp = await ServerConnections().postToServer(url: url, header: header, body: body, isBearer: isBearer);
    resp;
  }
}

//
// using System;
// using System.IO;
// using System.Security.Cryptography;
// using System.Text;
//
// namespace ARMCommon.Helpers
// {
// public class AES
// {
//   public string EncryptString(string plainText, string key)
//   {
//     using (Aes aesAlg = Aes.Create())
//     {
//     aesAlg.Key = Encoding.UTF8.GetBytes(key);
//     aesAlg.Mode = CipherMode.CFB; // Choose the appropriate mode
//     aesAlg.GenerateIV();
//
//     ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
//
//     using (MemoryStream msEncrypt = new MemoryStream())
//     {
//     using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
//     {
//     using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
//     {
//     swEncrypt.Write(plainText);
//     }
//     }
//
//     byte[] iv = aesAlg.IV;
//     byte[] encryptedBytes = msEncrypt.ToArray();
//
//     // Combine IV and encrypted data
//     byte[] combinedData = new byte[iv.Length + encryptedBytes.Length];
//     Array.Copy(iv, 0, combinedData, 0, iv.Length);
//     Array.Copy(encryptedBytes, 0, combinedData, iv.Length, encryptedBytes.Length);
//
//     return Convert.ToBase64String(combinedData);
//     }
//     }
//   }
//
//   public string DecryptString(string cipherText, string key)
//   {
//     byte[] combinedData = Convert.FromBase64String(cipherText);
//     byte[] iv = new byte[16]; // Assuming 128-bit AES
//     byte[] encryptedBytes = new byte[combinedData.Length - iv.Length];
//
//     Array.Copy(combinedData, iv, iv.Length);
//     Array.Copy(combinedData, iv.Length, encryptedBytes, 0, encryptedBytes.Length);
//
//     using (Aes aesAlg = Aes.Create())
//     {
//     aesAlg.Key = Encoding.UTF8.GetBytes(key);
//     aesAlg.Mode = CipherMode.CFB; // Choose the appropriate mode
//     aesAlg.IV = iv;
//
//     ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
//
//     using (MemoryStream msDecrypt = new MemoryStream(encryptedBytes))
//     {
//     using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
//     {
//     using (StreamReader srDecrypt = new StreamReader(csDecrypt))
//     {
//     return srDecrypt.ReadToEnd();
//     }
//     }
//     }
//     }
//   }
// }
// }
