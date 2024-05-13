import 'dart:convert';

import 'package:http/http.dart' as http;

//Classe che si occupa di inviare i dati al back-end
class ApiService {
  String ip = "192.168.91.92";
  //Metodo che invia i dati al back-end (Dati in formato stringa (La combo box e il testo inserito dall'utente))
  Future<String?> sendDataRiassumi(String data, int livello) async {
    var url = Uri.parse(
        'http://$ip:8000/summarize'); // Sostituisci con l'URL del tuo back-end
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
          String val = jsonDecode(response.body)['summary'];
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
    var url = Uri.parse(
        'http://$ip:8000/improve'); // Sostituisci con l'URL del tuo back-end
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
          String val = jsonDecode(response.body)['summary'];
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

  Future<String?> sendDataCreaRisposta(String data, int livello) async {
    var url = Uri.parse(
        'http://$ip:8000/reply'); // Sostituisci con l'URL del tuo back-end
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
          String val = jsonDecode(response.body)['summary'];
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

  //Metodo che invia il file Audio al back-end e riceve il testo trascritto
  Future<String?> inviaFileAudio(String percorso) async {
    var url = Uri.parse(
        'http://$ip:8000/send_data'); // Sostituisci con l'URL del tuo back-end
    var richiesta = http.MultipartRequest('POST', url);

    try {
      richiesta.files.add(await http.MultipartFile.fromPath('file', percorso));
      var risposta = await richiesta.send();

      if (risposta.statusCode == 200) {
        print('File caricato con successo');
        var rispostaStringa = await risposta.stream.bytesToString();
        var rispostaJson = jsonDecode(rispostaStringa);
        String val = rispostaJson['summary'];
        return val;
      } else {
        print('Errore nel caricamento del file: ${risposta.statusCode}');
        throw Exception(
            'Errore nel caricamento del file: ${risposta.statusCode}');
      }
    } catch (e) {
      print('Errore durante il caricamento del file: $e');
      throw Exception('Errore durante il caricamento del file: $e');
    }
  }

  //Metodo che invia il file Documento e restituisce il testo estratto
  Future<String?> inviaFileDocumento(String percorso) async {
    var url = Uri.parse(
        'http://$ip:8000/upload_file'); // Sostituisci con l'URL del tuo back-end
    var richiesta = http.MultipartRequest('POST', url);

    try {
      richiesta.files.add(await http.MultipartFile.fromPath('file', percorso));
      var risposta = await richiesta.send();

      if (risposta.statusCode == 200) {
        print('File caricato con successo');
        var rispostaStringa = await risposta.stream.bytesToString();
        String val = jsonDecode(rispostaStringa)['summary'];
        return val;
      } else {
        print('Errore nel caricamento del file: ${risposta.statusCode}');
        throw Exception(
            'Errore nel caricamento del file: ${risposta.statusCode}');
      }
    } catch (e) {
      print('Errore durante il caricamento del file: $e');
      throw Exception('Errore durante il caricamento del file: $e');
    }
  }

  //ApiService Login
  Future<String?> login(String email, String password) async {
    var url = Uri.parse('http://$ip:8000/login');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        print('Login effettuato con successo');
        String val = jsonDecode(response.body)['token'];
        return val;
      } else {
        print('Errore nel login: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante il login: $e');
    }
    return null;
  }

  //ApiService Registrazione
  Future<bool> register(String email, String password) async {
    var url = Uri.parse('http://$ip:8000/register');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        print('Registrazione effettuata con successo');
        return true;
      } else {
        print('Errore nella registrazione: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la registrazione: $e');
    }
    return false;
  }


  //Aggiunta metodo per la carta intestata
}
