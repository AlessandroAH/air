import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'documenti_page.dart'; // Importa la tua classe DocumentiPage
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

//Valori possibili per la lunghezza della risposta
enum RispostaLunghezza { bassa, media, alta }

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
class _MyAppState extends State<MyApp> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final ApiService apiService = ApiService();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  String? _path;

  String dropdownValue = 'Riassumi';
  RispostaLunghezza _rispostaLunghezza = RispostaLunghezza.bassa;

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
  Future<void> _record() async {
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
        } else {
          print('Unable to get the external storage directory');
        }
      } else {
        print('Microphone or storage permission not granted');
      }
    } catch (e) {
      print('Error occurred while recording: $e');
    }
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
  Future<void> _uploadFile() async {
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
        }
      } else {
        print('Unable to get the external storage directory');
      }
    } else {
      print('No file selected');
    }
  }

//Metodo build per la creazione dell'interfaccia grafica
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.account_circle),
          title: Text('Nome Utente'),
          actions: <Widget>[
            DropdownButton<String>(
              items: <String>['Italiano', 'Inglese', 'Francese']
                  .map((String value) {
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
                    child: Text(value),
                  );
                }).toList(),
              ),
              ListTile(
                title: const Text('Lunghezza Risposta:'),
                trailing: DropdownButton<RispostaLunghezza>(
                  value: _rispostaLunghezza,
                  onChanged: (RispostaLunghezza? newValue) {
                    setState(() {
                      _rispostaLunghezza = newValue!;
                    });
                  },
                  items: RispostaLunghezza.values.map((RispostaLunghezza value) {
                    return DropdownMenuItem<RispostaLunghezza>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                child: Text('Invia'),
                onPressed: () {
                  apiService
                      .sendData(controller1.text + "," + controller1.text + "," + _rispostaLunghezza.toString());
                },
              ),
              TextField(
                controller: controller2,
                decoration: InputDecoration(
                  hintText: 'Risoposta...',
                ),
                enabled: false,
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
            onTap: (int index) async {
              switch (index) {
                case 0:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DocumentiPage()));
                  break;
                case 1:
                  await _record();
                  await Future.delayed(
                      Duration(seconds: 5)); // Record for 1 second
                  await _stop();
                  break;
                case 2:
                  await _uploadFile();
                  break;
              }
            },
          );
        }),
      ),
    );
  }
}