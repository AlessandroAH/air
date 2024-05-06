import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/services/api_service.dart';

class DocumentiPage extends StatefulWidget {
  @override
  _DocumentiPageState createState() => _DocumentiPageState();
}

class _DocumentiPageState extends State<DocumentiPage> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService();
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    } else {
      print('No file selected');
    }
  }

  void _sendData() {
    //apiService.sendData(_controller.text + "," + _fileName!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Documenti')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Carica carta intestata'),
              onPressed: _pickFile,
            ),
            Text(_fileName ?? 'Nessun file selezionato'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Inserisci del testo',
              ),
            ),
            ElevatedButton(
              child: Text('Invia'),
              onPressed: _sendData,
            ),
          ],
        ),
      ),
    );
  }
}