import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpServer {
  static String url = "";
  static String token = "";
  static final Map<String, String> _header = {};

  static void init() {
    url = dotenv.get("SERVER_URL");
  }
  static void setToken(String token_) {
    token = token_;
    _header["cookie"] = "token=$token;";
  }

  static Future<http.Response> fetchServerAPI(String path) async {
    return http.post(
      Uri.parse("$url/api/$path"),
      headers: _header,
      body: {
        "token": token,
      },
    );
  }

  static String imageUrl(String imagePath, bool isSmall) {
    return "$url/api/getImage?token=$token&image=$imagePath${isSmall ? "&size=s" : ""}";
  }
}