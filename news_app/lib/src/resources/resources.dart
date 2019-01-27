import 'dart:async';
import 'new_api_provider.dart';
import 'new_db_provider.dart';
import '../models/itemModel.dart';
import 'listener.dart';

class Repository{

  List<Source> sources = <Source>[
    newDbProvider,
    NewApiProvider()
  ];

  List<Cache> caches = <Cache>[
    newDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for(source in sources){
      item = await source.fetchItem(id);
      if(item != null){
        break;
      }
    }

    for(var cache in caches){
      if (cache != source){
        cache.addItem(item);
      }
    }
    return item;
  }

  clearCache() async{
    for(var cache in caches){
      await cache.clear();
    }
  }
}