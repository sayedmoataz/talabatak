import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../core/network/local/DbHelper.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
      'AAAAvi_IvPM:APA91bGI89wHItYcq3CIOdYoV7E64PawVVxyHYceDd1JF4m3qci-mXP08yEC-DMfFqhKuZ39jVJx3fXpMA_4qk0aaN_0MdDArYZo_7i0m2udGIiNX16WyxlFdXDrHFpbm_ZFeoZquYDH';


  static Future<Response> sendTo({
    required String title,
    required String body,
  }) =>
      client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '/topics/all',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );

  static Future<Response> sendToo({
    required String title,
    required String body,
    required String token,

  }) =>
      client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '/topics/${CacheHelper.getData(key: 'email').replaceAll("@",'').replaceAll(".",'').replaceAll("-",'')}',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
