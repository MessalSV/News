import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'bloc/stories_provider.dart';
import 'screens/news_detail.dart';
import 'bloc/comments_provider.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings setting){
    if (setting.name == '/'){
      return MaterialPageRoute(
        builder: (context){
          final storiesBloc = StoriesProvider.of(context);
          
          storiesBloc.fetchTopIds();
          return NewList();
        }
      );
    } else{
      return MaterialPageRoute(
        builder: (context){
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(setting.name.replaceFirst('/', ''));

          commentsBloc.fetchItemWithComments(itemId);
          return NewsDetail(itemId: itemId,); 
        }
      );
    }
  }
}