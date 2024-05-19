import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project2/models/photos_model.dart';

class PhotoApi {
  final Dio dio = Dio();

  Future<List<Photo>> getPhotos({String query = 'nature'}) async {
    const url = 'https://api.pexels.com/v1/search';

    const String apiKey =
        '8uSS1jWsMIgLPIySvtnuGY13SMmc9UEuOWqld2Xcv7tJ9s84dRtwOpk3';
    final Response<String> response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': apiKey,
        },
      ),
      queryParameters: {'query': query},
    );

    if (response.statusCode == 200) {
      print('object');
      final decodedResponse =
          jsonDecode(response.data!) as Map<String, dynamic>;
      final photoList = decodedResponse['photos'] as List<dynamic>;
      return photoList.map((e) => Photo.fromJson(e)).toList();
    }
    return [];
  }
}
