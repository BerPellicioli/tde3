import 'package:flutter/material.dart';
import 'call_api.dart';
import 'consult_api_extended.dart';

class TopArtistsPage extends StatefulWidget {
  const TopArtistsPage({Key? key}) : super(key: key);

  @override
  State<TopArtistsPage> createState() => _TopArtistsPageState();
}

class _TopArtistsPageState extends State<TopArtistsPage> {
  List<dynamic> artistList = [];

  @override
  void initState() {
    super.initState();
    _fetchTopArtists();
  }

  Future<void> _fetchTopArtists() async {
    List<dynamic> data = await CallApi.fetchTopArtists();
    setState(() {
      artistList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 10 Artistas do Momento'),
      ),
      body: SafeArea(
        child: artistList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: artistList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(artistList[index]['name']),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConsultApiExtended(
                            artistName: artistList[index]['name'],
                            limit: 10,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
