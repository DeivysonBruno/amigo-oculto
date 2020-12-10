
import 'package:email_validator/email_validator.dart';

String validateField(String text) {
  if (text.isEmpty) return "Campo obrigatório";
  return null;
}


String validateEmail(String text) {
  if (text.isEmpty) return "Campo obrigatório";
  if (!EmailValidator.validate(text)) return "Entre com um email válido";
  return null;
}