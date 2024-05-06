import 'dart:convert';

import 'package:http/http.dart' as http;

//Classe che si occupa di inviare i dati al back-end
class ApiService {
  //Metodo che invia i dati al back-end (Dati in formato stringa (La combo box e il testo inserito dall'utente))
  Future<String?> sendDataRiassumi(String data, int livello) async {
    var url = Uri.parse('http://192.168.71.92:8000/summarize'); // Sostituisci con l'URL del tuo back-end
    //Riempe il body della richiesta con i dati da inviare
    if (livello >= 0 && livello < 3) {
      try {
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'text': data, "level": livello.toString()}),
        );
  
        // Se la richiesta ha avuto successo, stampa un messaggio di successo
        if (response.statusCode == 200) {
          print('Dati inviati con successo');
            String val = jsonDecode(response.body);
          return val;
        } else {
          print('Errore nel inviare i dati: ${response.statusCode}');
        }
      } catch (e) {
        print('Errore durante l\'invio dei dati: $e');
      }
    }
      return null;
  }

  Future<String?> sendDataMigliora(String data, int livello) async {
    var url = Uri.parse('http://172.22.169.123:80000/improve'); // Sostituisci con l'URL del tuo back-end
    //Riempe il body della richiesta con i dati da inviare
    if (livello >= 0 && livello < 3) {
      try {
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {'text': data, "level": livello.toString()},
        );

        // Se la richiesta ha avuto successo, stampa un messaggio di successo
        if (response.statusCode == 200) {
          print('Dati inviati con successo');
          return response.body;
        } else {
          print('Errore nel inviare i dati: ${response.statusCode}');
        }
      } catch (e) {
        print('Errore durante l\'invio dei dati: $e');
      }
    }
    return null;
  }

  Future<String?> sendDataCreaRisposta(String data, int livello) async {
    var url = Uri.parse('http://172.22.169.123:8000/reply'); // Sostituisci con l'URL del tuo back-end
    //Riempe il body della richiesta con i dati da inviare
    if (livello >= 0 && livello < 3) {
      try {
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {'text': data, "level": livello.toString()},
        );

        // Se la richiesta ha avuto successo, stampa un messaggio di successo
        if (response.statusCode == 200) {
          print('Dati inviati con successo');
          return response.body;
        } else {
          print('Errore nel inviare i dati: ${response.statusCode}');
        }
      } catch (e) {
        print('Errore durante l\'invio dei dati: $e');
      }
    }
    return null;
  }

  //Metodo che invia il file
  Future<void> inviaFile(String percorso) async {
    var url = Uri.parse(
        'http://172.22.169.123:8000'); // Sostituisci con l'URL del tuo back-end
    var richiesta = http.MultipartRequest('POST', url);

    try {
      richiesta.files.add(await http.MultipartFile.fromPath('file', percorso));
      var risposta = await richiesta.send();

      if (risposta.statusCode == 200) {
        print('File caricato con successo');
      } else {
        print('Errore nel caricamento del file: ${risposta.statusCode}');
      }
    } catch (e) {
      print('Errore durante il caricamento del file: $e');
    }
  }

}
