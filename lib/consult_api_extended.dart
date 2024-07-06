import 'package:flutter/material.dart';
import 'call_api.dart';

class ConsultApiExtended extends StatefulWidget {
  final String artistName;
  final int limit;

  const ConsultApiExtended(
      {Key? key, required this.artistName, this.limit = 100})
      : super(key: key);

  @override
  State<ConsultApiExtended> createState() => _ConsultApiExtendedState();
}

class _ConsultApiExtendedState extends State<ConsultApiExtended> {
  String msg = 'Carregando músicas...';
  List<dynamic> musicList = [];

  @override
  void initState() {
    super.initState();
    _fetchTopSongs();
  }

  void _fetchTopSongs() async {
    List<dynamic> data =
        await CallApi.fetchTopSongs(widget.artistName, widget.limit);
    setState(() {
      if (data.isEmpty) {
        msg = 'Nenhuma música encontrada para o artista ${widget.artistName}';
        musicList.clear();
      } else {
        msg = 'Top ${widget.limit} músicas de ${widget.artistName}';
        musicList = data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Músicas'),
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
            ],
          ),
        ),
      ),
    );
  }
}
