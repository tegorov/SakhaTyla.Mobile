import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/random_article/random_article.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';
import 'package:sakhatyla/home/view/search_bar.dart';
import 'package:sakhatyla/home/view/suggestion_list.dart';
import 'package:sakhatyla/home/view/translation_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Саха Тыла"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              api: locator<ApiClient>(),
              database: locator<AppDatabase>()
            ),
          ),
          BlocProvider(
            create: (context) =>
                RandomArticleBloc(api: locator<ApiClient>())..add(Load()),
          ),
        ],
        child: Column(
          children: <Widget>[
            SearchBar(),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeEmpty) {
                  return RandomArticle();
                }
                if (state is HomeSearching) {
                  return Expanded(child: SuggestionList(state.suggestions));
                }
                if (state is HomeHistory) {
                  return Expanded(child: SuggestionList(state.suggestions));
                }
                if (state is HomeLoading) {
                  return CircularProgressIndicator();
                }
                if (state is HomeSuccess) {
                  return Expanded(child: TranslationList(state.translation));
                }
                if (state is HomeError) {
                  return Text('${state.error}');
                }
                return Text('');
              },
            ),
          ],
        ),
      ),
    );
  }
}
