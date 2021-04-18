import 'dart:io';

import 'package:enough_mail/enough_mail.dart';

String userName = 'geraa1985dev';
String password = 'GerasimovAA@1985dev';
String domain = 'gmail.com';
String from = 'UnionPlayer';
String to = 'Admin';

String smtpServerHost = 'smtp.$domain';
int smtpServerPort = 465;
bool isSmtpServerSecure = true;

void main() async {
  try {
    await smtpExample();
  } catch (e, s) {
    print('unhandled exception $e');
    print(s);
  }
  exit(0);
}

Future<void> smtpExample() async {
  final client = SmtpClient('gmail.com', isLogEnabled: true);
  try {
    await client.connectToServer(smtpServerHost, smtpServerPort,
        isSecure: isSmtpServerSecure);
    await client.ehlo();
    if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
      await client.authenticate(userName, password, AuthMechanism.plain);
    } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
      await client.authenticate(userName, password, AuthMechanism.login);
    } else {
      return;
    }
    final builder = MessageBuilder.prepareMultipartAlternativeMessage();
    builder.from = [MailAddress(from, '$userName@$domain')];
    builder.to = [MailAddress(to, 'geraa1985@gmail.com')];
    builder.subject = 'My first message';
    builder.addTextPlain('hello world.');
    builder.addTextHtml('<p>hello <b>world</b></p>');
    final mimeMessage = builder.buildMimeMessage();
    final sendResponse = await client.sendMessage(mimeMessage);
    print('message sent: ${sendResponse.isOkStatus}');
  } on SmtpException catch (e) {
    print('SMTP failed with $e');
  }
}
