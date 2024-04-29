import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'documenti_page.dart'; // Importa la tua classe DocumentiPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final ApiService apiService = ApiService();

  String dropdownValue = 'Riassumi';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.account_circle),
          title: Text('Nome Utente'),
          actions: <Widget>[
            DropdownButton<String>(
              items: <String>['Italiano', 'Inglese', 'Francese'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller1,
                decoration: InputDecoration(
                  hintText: 'Inserisci dei dati',
                ),
              ),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  // Accetta un argomento String? invece di String
                  dropdownValue = newValue!;
                },
                items: <String>['Riassumi', 'Migliora', 'Crea risposta adeguata']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                child: Text('Invia'),
                onPressed: () {
                  apiService.sendData(controller1.text);
                },
              ),
              TextField(
                controller: controller2,
                decoration: InputDecoration(
                  hintText: 'Inserisci altri dati',
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Builder(builder: (BuildContext context) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Documenti',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.audiotrack),
                label: 'Audio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload_file),
                label: 'Upload',
              ),
            ],
            onTap: (int index) {
              switch (index) {
                case 0:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentiPage()));
                  break;
              }
            },
          );
        }),
      ),
    );
  }
}