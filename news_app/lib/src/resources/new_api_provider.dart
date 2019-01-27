import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/itemModel.dart';
import 'listener.dart';

class NewApiProvider implements Source {
  final Client client = Client();

  Future<ItemModel> fetchItem(int id) async{
    final response = await client.get('https://hacker-news.firebaseio.com/v0/item/$id.json');
    final item = json.decode(response.body);
    return ItemModel.fromJson(item);
  }

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get('https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty');
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }
}