import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../resources/resources.dart';
import '../models/itemModel.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Stream
  Observable<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;

  // Sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc(){
    _commentsFetcher.stream.transform(_commentsTransformer()).pipe(_commentsOutput);
  }

  _commentsTransformer(){
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, int index){
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item){
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{}
    );
  }

  dispose(){
    _commentsFetcher.close();
    _commentsOutput.close();
  }

}