import 'package:http/http.dart' as http;

class ApiService {
  Future<void> sendData(String data) async {
    var url = Uri.parse('http://127.0.0.1:5000'); // Sostituisci con l'URL del tuo back-end
    var response = await http.post(url, body: {'data': data});

    if (response.statusCode == 200) {
      print('Dati inviati con successo');
    } else {
      print('Errore nel inviare i dati: ${response.statusCode}');
    }
  }
}