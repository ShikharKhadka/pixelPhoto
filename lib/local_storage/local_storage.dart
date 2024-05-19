import 'dart:convert';

import 'package:project2/models/like_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<SharedPreferences>? _prefsFuture;

  Future<SharedPreferences> get prefs async {
    _prefsFuture ??= SharedPreferences.getInstance();
    return _prefsFuture!;
  }

  Future<List<LikeModel>> getString() async {
    final pref = await prefs;
    final data = pref.getString('like');
    final list = jsonDecode(data!) as List<dynamic>;
    final likeList = list.map((e) => LikeModel.fromJson(e)).toList();
    return likeList.isEmpty ? [] : likeList;
  }

  Future<void> setString(LikeModel value) async {
    final pref = await prefs;
    final list = [];
    list.add(value);
    print(list);
    await pref.setString('like', jsonEncode(list));
  }
}
