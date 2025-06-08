import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String _token = "";

void setToken(String token) {
  _token = token;
}

Future<http.Response> fetchServerAPI(
  String path,
) async {
  final url = dotenv.get("SERVER_URL");
  return http.post(
    Uri.parse("$url/api/$path"),
    body: {
      "token": _token,
    },
  );
}