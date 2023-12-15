import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/main.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen({Key? key}) : super(key: key);

  @override
  _LanguageChangeScreenState createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here (if needed)
        // For example, you can return false to prevent the user from going back.
        return true; // Allow the user to go back
      },
      child: Scaffold(
        appBar: TitleNavBar(
            title: AppLocalizations.of(context)!.selectLanguageText),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('English'),
              trailing: _selectedLocale?.languageCode == 'en'
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _selectedLocale = const Locale('en', 'US');
                  MyApp.setLocale(context, _selectedLocale!);
                });
              },
            ),
            const Divider(),
            // Add more languages as needed
          ],
        ),
      ),
    );
  }
}
