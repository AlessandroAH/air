import 'package:http/http.dart' as http;

//Classe che si occupa di inviare i dati al back-end
class ApiService {

  //Metodo che invia i dati al back-end (Dati in formato stringa (La combo box e il testo inserito dall'utente))
  Future<void> sendData(String data) async {
    var url = Uri.parse('http://192.168.1.45:5000'); // Sostituisci con l'URL del tuo back-end
    //Riempe il body della richiesta con i dati da inviare
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'data': data},
      );

      // Se la richiesta ha avuto successo, stampa un messaggio di successo
      if (response.statusCode == 200) {
        print('Dati inviati con successo');
      } else {
        print('Errore nel inviare i dati: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante l\'invio dei dati: $e');
    }
  }
}