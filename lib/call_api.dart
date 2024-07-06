import 'dart:isolate';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallApi {
  static Future<List<dynamic>> fetchTopSongs(String artistName,
      [int limit = 10]) async {
    final receivePort = ReceivePort();
    Isolate.spawn(_callDeezerApi, [receivePort.sendPort, artistName, limit]);

    return await receivePort.first;
  }

  static void _callDeezerApi(List<dynamic> args) async {
    SendPort sp = args[0];
    String artistName = args[1];
    int limit = args[2];

    final searchUrl = 'https://api.deezer.com/search?q=artist:"$artistName"';
    final searchResponse = await http.get(Uri.parse(searchUrl));

    if (searchResponse.statusCode == 200) {
      final searchData = json.decode(searchResponse.body);
      if (searchData['data'].isNotEmpty) {
        final artistId = searchData['data'][0]['artist']['id'];
        final topSongsUrl =
            'https://api.deezer.com/artist/$artistId/top?limit=$limit';
        print('URL das top músicas: $topSongsUrl');
        final topSongsResponse = await http.get(Uri.parse(topSongsUrl));

        if (topSongsResponse.statusCode == 200) {
          final topSongsData = json.decode(topSongsResponse.body)['data'];
          sp.send(topSongsData);
        } else {
          sp.send([]);
        }
      } else {
        sp.send([]);
      }
    } else {
      sp.send([]);
    }
  }
}
