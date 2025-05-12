import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class I10n {
  static final I10n _instance = I10n._internal();
  factory I10n() => _instance;
  I10n._internal();

  late AppLocalizations _localizations;

  void initialize(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get localizations => _localizations;
}
