import 'package:cloud_firestore/cloud_firestore.dart';

class EmailData {
  String account = "";
  String password = "";
  String smtpCrypto = "";
  String smtpServer = "";
  int smtpPort = 0;
  List<String> mailingList = List.empty(growable: true);

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      account = doc["account"];
      password = doc["password"];
      smtpCrypto = doc["smtp_crypto"];
      smtpPort = doc["smtp_port"];
      smtpServer = doc["smtp_server"];
      mailingList = List.from(doc["mailing_list"]);
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}