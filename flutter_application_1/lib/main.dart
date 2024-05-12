import 'package:flutter/material.dart';
import 'package:AIR/login_page.dart';
import 'package:AIR/services/api_service.dart';
import 'documenti_page.dart'; // Importa la tua classe DocumentiPage
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

//Valori possibili per la lunghezza della risposta
enum RispostaLunghezza { bassa, media, alta }

int selectedIndex =
    0; // Aggiungi questa variabile per tenere traccia dell'indice selezionato

//Classe principale dell'applicazione
void main() {
  runApp(MyApp());
}

//Classe per la creazione dell'interfaccia grafica
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//Classe per la creazione dell'interfaccia grafica
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final ApiService apiService = ApiService();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  String? _path;

  //Variabili per la selezione del tipo di risposta
  String dropdownValue = 'Riassumi';
  RispostaLunghezza _rispostaLunghezza = RispostaLunghezza.bassa;

  //Variabili per il login utente
  bool _isUserLoggedIn = false;
  String _username = 'Nome Utente';

  //Metodi per la registrazione audio

  //Metodo per aprire la sessione audio
  @override
  void initState() {
    super.initState();
    _recorder!.openAudioSession().then((value) {
      setState(() {});
    });
  }

  //Metodo per chiudere la sessione audio
  @override
  void dispose() {
    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  //Metodo per registrare l'audio
  Future<String?> _record() async {
    try {
      if (await Permission.microphone.request().isGranted &&
          await Permission.manageExternalStorage.request().isGranted) {
        Directory? appDirectory = await getExternalStorageDirectory();
        if (appDirectory != null) {
          _path = '${appDirectory.path}/flutter_sound-tmp.wav';
          print(_path);
          if (_recorder!.isStopped) {
            await _recorder!
                .startRecorder(toFile: _path, codec: Codec.pcm16WAV);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Recording started')));
          }
          return _path;
        } else {
          print('Unable to get the external storage directory');
        }
      } else {
        print('Microphone or storage permission not granted');
      }
    } catch (e) {
      print('Error occurred while recording: $e');
    }
    return null;
  }

//Metodo per fermare la registrazione audio
  Future<void> _stop() async {
    try {
      if (!_recorder!.isStopped) {
        await _recorder!.stopRecorder();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Recording stopped')));
      }
    } catch (e) {
      print('Error occurred while stopping the recorder: $e');
    }
  }

//Metodo per caricare un file
  Future<String?> _uploadFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      Directory? appDirectory = await getExternalStorageDirectory();
      if (appDirectory != null) {
        for (var platformFile in result.files) {
          File file = File(platformFile.path!);
          final String newPath =
              '${appDirectory.path}/${file.path.split('/').last}';
          await file.copy(newPath);
          print('File copied to $newPath');
          return newPath;
        }
      } else {
        print('Unable to get the external storage directory');
      }
    } else {
      print('No file selected');
    }
    return null;
  }

  Future<void> inviaDati() async {
    switch (dropdownValue) {
      case 'Riassumi':
        controller2.text = (await apiService.sendDataRiassumi(
            controller1.text, selectedIndex))!;
        break;
      case 'Migliora':
        controller2.text = (await apiService.sendDataMigliora(
            controller1.text, selectedIndex))!;
        break;
      case 'Crea risposta adeguata':
        controller2.text = (await apiService.sendDataCreaRisposta(
            controller1.text, selectedIndex))!;
        break;
      default:
        print('Selezione non valida');
    }
  }

//Metodo build per la creazione dell'interfaccia grafica
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1, // Numero di tabs
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return _isUserLoggedIn // Modifica questa parte
                    ? Icon(Icons.account_circle)
                    : Theme(
                        data: Theme.of(context).copyWith(
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  Color.fromARGB(255, 199, 130, 255),
                            ),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage()), // Naviga alla pagina di login
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.login), // Usa un'icona che preferisci
                              Text(
                                'Login',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
            title: _isUserLoggedIn ? Text(_username) : null,
            actions: <Widget>[
              DropdownButton<String>(
                items: <String>['Italiano'] //'Inglese', 'Francese'
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Aggiunge 16 pixel di spazio intorno al TextField
                  child: TextField(
                    controller: controller1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(
                          255, 204, 255, 145), // Imposta il colore di sfondo
                      hintText: 'Inserisci dei dati',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 204, 255, 145),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Color.fromARGB(255, 204, 255, 145),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'Riassumi',
                          'Migliora',
                          'Crea risposta adeguata'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              width: 200, // Devi impostare una larghezza fissa
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 204, 255, 145),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(value),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Lunghezza Risposta:'),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 204, 255, 145),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Color.fromARGB(255, 204, 255,
                              145), // Questo colora le opzioni del menu
                        ),
                        child: DropdownButton<RispostaLunghezza>(
                          value: _rispostaLunghezza,
                          onChanged: (RispostaLunghezza? newValue) {
                            setState(() {
                              _rispostaLunghezza = newValue!;
                              selectedIndex =
                                  RispostaLunghezza.values.indexOf(newValue);
                            });
                          },
                          items: RispostaLunghezza.values
                              .map((RispostaLunghezza value) {
                            return DropdownMenuItem<RispostaLunghezza>(
                              value: value,
                              child: Container(
                                width:
                                    100, // Devi impostare una larghezza fissa
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      20), // Questo arrotonda le opzioni
                                  color: Color.fromARGB(255, 204, 255, 145),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(value.toString().split('.').last),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 199, 130,
                        255), // Questo cambia il colore del testo
                  ),
                  child: Text('Invia'),
                  onPressed: inviaDati,
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Aggiunge 16 pixel di spazio intorno al Container
                  child: Container(
                    color: Color.fromARGB(255, 204, 255, 145),
                    child: SelectableText(
                      controller2.text,
                      showCursor: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Builder(builder: (BuildContext context) {
            return BottomNavigationBar(
              backgroundColor: Color.fromARGB(255, 204, 255, 145),
              selectedItemColor: Color.fromARGB(255, 199, 130, 255),
              unselectedItemColor:
                  Color.fromARGB(255, 199, 130, 255).withOpacity(0.6),
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
              onTap: (int index) async {
                switch (index) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentiPage()));
                    break;
                  case 1:
                    String? filePath = await _record();
                    await Future.delayed(
                        Duration(seconds: 5)); // Record for 5 seconds
                    await _stop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Audio inviato con successo')));
                    controller2.text =
                        (await apiService.inviaFileAudio(filePath!))!;
                    break;
                  case 2:
                    String? fileDoc = await _uploadFile();
                    controller2.text =
                        (await apiService.inviaFileDocumento(fileDoc!))!;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('File inviato con successo')));
                    break;
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
