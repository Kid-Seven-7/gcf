import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MailEngine {
  String _username = "gcfdevteam@gmail.com";
  String _password = "gcfpassword";

  void sendMail(String _recipient, String _recipientMessage, String _subject,
      String _errorCode) async {
    final _smtpServer = gmail(_username, _password);

    final _message = new Message()
      ..from = new Address(_username, "GCF DEV TEAM")
      ..recipients.add(_recipient)
      ..subject = _subject
      ..text = _recipientMessage;
    try {
      await send(_message, _smtpServer);
    } catch (e) {
      print("Error found: Error code: $_errorCode:: $e");
    }
  }
}
