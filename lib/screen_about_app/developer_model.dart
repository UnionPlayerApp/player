import 'package:union_player_app/common/enums/string_keys.dart';

class DeveloperModel {
  final StringKeys roleKey;
  final String firstName;
  final String lastName;
  final String? email;
  final String? whatsapp;
  final String? telegram;

  const DeveloperModel({
    required this.roleKey,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.whatsapp,
    required this.telegram,
  });
}
