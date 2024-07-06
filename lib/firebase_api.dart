import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'top_artists_page.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const TopArtistsPage(),
        ),
      );
    });
  }
}
