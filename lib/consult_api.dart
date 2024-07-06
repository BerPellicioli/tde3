import 'package:flutter/material.dart';
import 'call_api.dart';
import 'consult_api_extended.dart';

class ConsultApi extends StatefulWidget {
  const ConsultApi({Key? key}) : super(key: key);

  @override
  State<ConsultApi> createState() => _ConsultApiState();
}

class _ConsultApiState extends State<ConsultApi> {
  String msg = 'Digite o nome de um artista';
  List<dynamic> musicList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 10 Músicas do Artista'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                msg,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do Artista',
                  ),
                ),
              ),
              musicList.isEmpty
                  ? const Text('Nenhuma música encontrada')
                  : Expanded(
                      child: ListView.builder(
                        itemCount: musicList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(musicList[index]['title']),
                            subtitle: Text(musicList[index]['artist']['name']),
                          );
                        },
                      ),
                    ),
              ElevatedButton(
                onPressed: () async {
                  final artistName = _controller.text;
                  if (artistName.isEmpty) {
                    setState(() {
                      msg = 'Por favor, digite o nome de um artista';
                    });
                    return;
                  }

                  List<dynamic> data = await CallApi.fetchTopSongs(artistName);
                  setState(() {
                    if (data.isEmpty) {
                      msg =
                          'Nenhuma música encontrada para o artista $artistName';
                      musicList.clear();
                    } else {
                      msg = 'Top 10 músicas de $artistName';
                      musicList = data;
                      _showPopupMessage(context, artistName);
                    }
                  });
                },
                child: const Text('Buscar Músicas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupMessage(BuildContext context, String artistName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consulta Realizada'),
          content: Text('Top 10 músicas de $artistName'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo antes de navegar
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ConsultApiExtended(artistName: artistName, limit: 100),
                  ),
                );
              },
              child: const Text('Ver Lista de 100 Músicas'),
            ),
          ],
        );
      },
    );
  }
}
