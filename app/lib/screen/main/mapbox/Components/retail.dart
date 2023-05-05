import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/model/skin.dart';

Future<Skin> retailSkin(AppState appState) async {
  String url =
      'https://pro-hikup.westeurope.cloudapp.azure.com/api/skin/retrieve';
  String token = appState.token;
  Map<String, dynamic> requestBody = {
    "user": {"id": appState.id, "roles": appState.roles}
  };
  var response = await http.post(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestBody));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    print(data);
    Skin skin = Skin.fromMap(data: data["skin"] ?? {});
    return (skin);
  } else {
    return (appState.skin);
  }
}
