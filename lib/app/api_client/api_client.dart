import 'package:http/http.dart' as http;
import 'package:movie_list_tmdb/app/failure/exceptions.dart';

class APIClient {
  String baseUrl = "https://api.themoviedb.org";
  String apiKey = "503581f00344bdaaa2bda262d1d20690";
  String token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MDM1ODFmMDAzNDRiZGFhYTJiZGEyNjJkMWQyMDY5MCIsIm5iZiI6MTczNTM2MTkyOC41MDcsInN1YiI6IjY3NmY4NTg4MmM5MDk3YjI2NjYxNzkxNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7JLPeya40UhXYVGk41bqFfEALmDjj6mMGR8ZdWGJOaQ";
  get(String endpoint) async {
    http.Response response = await http
        .get(Uri.parse("$baseUrl$endpoint?api_key=$apiKey"), headers: {
      "Authorization": "Bearer $token"
    }).timeout(Duration(seconds: 10), onTimeout: () {
      throw TimeoutException();
    });
    return _handlerResponse(response);
  }

  String _handlerResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ClientException();
    } else if (response.statusCode >= 500) {
      throw ServerException();
    } else {
      throw Exception("Failed to load data");
    }
  }
}
