import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _zipController = TextEditingController();

  Future<String>? _cityFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 32,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _zipController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postleitzahl",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gib eine Postleitzahl ein';
                    }
                    if (value.length != 5) {
                      return 'Postleitzahl muss 5 Ziffern lang sein';
                    }
                    return null;
                  },
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Validierung des Formulars
                  _submitForm();
                  // TODO: implementiere Suche
                  if (_zipController.text.isNotEmpty) {
                    setState(() {
                      _cityFuture = getCityFromZip(_zipController.text);
                    });
                  }
                },
                child: const Text("Suche"),
              ),
              const SizedBox(
                height: 32,
              ),
              // FutureBuilder
              FutureBuilder<String>(
                future: _cityFuture,
                builder: (context, snapshot) {
                  // Zustand: Warten auf das Ergebnis
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  // Zustand: Abgeschlossen mit Fehler
                  if (snapshot.hasError) {
                    return Text(
                      'Fehler: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  // Zustand: Abgeschlossen mit Daten
                  if (snapshot.hasData) {
                    return Text(
                      'Ergebnis: ${snapshot.data}',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  }
                  // Initialer Zustand (bevor eine Suche gestartet wurde)
                  return Text(
                    "Ergebnis: Noch keine PLZ gesucht",
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: dispose controllers
    _zipController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Wenn das Formular gültig ist, führe die gewünschte Aktion aus
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formular erfolgreich gesendet!')),
      );
    }
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        // return 'Unbekannte Stadt';
        // Dies löst snapshot.hasError im FutureBuilder aus.
        throw Exception('PLZ nicht gefunden');
    }
  }
}
