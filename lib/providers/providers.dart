import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project2/api/photos_api.dart';
import 'package:project2/models/photos_model.dart';


class MyNotifier extends AsyncNotifier<List<Photo>> {
  @override
  Future<List<Photo>> build() async {
    return PhotoApi().getPhotos();
  }

  Future<void> searchPhotos({required String name}) async {
    final photo = await PhotoApi().getPhotos(query: name);
    state = state.whenData((value) {
      final List<Photo> data = photo;
      return data;
    });
  }
}

final photoProvider =
    AsyncNotifierProvider<MyNotifier, List<Photo>>(MyNotifier.new);
