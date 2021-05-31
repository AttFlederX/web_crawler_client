import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:web_crawler_client/helpers/consts.dart';
import 'package:web_crawler_client/models/news_item.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<String> _categoriesShown;
  VoidCallback _refetch;

  @override
  void initState() {
    super.initState();

    _categoriesShown = [
      worldCategoryName,
      usNewsCategoryName,
      politicsCategoryName,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [Text('News items')],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _categoriesShown.contains(worldCategoryName),
                  onChanged: (val) {
                    setState(() {
                      val
                          ? _categoriesShown.add(worldCategoryName)
                          : _categoriesShown.remove(worldCategoryName);
                      _refetch();
                    });
                  },
                ),
                Text('World'),
                Checkbox(
                  value: _categoriesShown.contains(usNewsCategoryName),
                  onChanged: (val) {
                    setState(() {
                      val
                          ? _categoriesShown.add(usNewsCategoryName)
                          : _categoriesShown.remove(usNewsCategoryName);
                      _refetch();
                    });
                  },
                ),
                Text('U.S.'),
                Checkbox(
                  value: _categoriesShown.contains(politicsCategoryName),
                  onChanged: (val) {
                    setState(() {
                      val
                          ? _categoriesShown.add(politicsCategoryName)
                          : _categoriesShown.remove(politicsCategoryName);
                      _refetch();
                    });
                  },
                ),
                Text('Politics'),
              ],
            ),
            Expanded(
              child: Query(
                options: QueryOptions(
                  document: gql(
                      getNewsItemsQuery), // this is the query string you just created
                  pollInterval: Duration(seconds: 10),
                ),
                // Just like in apollo refetch() could be used to manually trigger a refetch
                // while fetchMore() can be used for pagination purpose
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return Text('Loading');
                  }

                  _refetch = refetch;

                  // it can be either Map or List
                  var newsItems = (result.data['allNewsItems'] as List)
                      .map((ni) => NewsItem.fromJson(ni))
                      .where((ni) => _categoriesShown.contains(ni.category))
                      .toList();

                  newsItems.sort((ni1, ni2) => -ni1.added.compareTo(ni2.added));

                  return ListView.builder(
                      itemCount: newsItems.length,
                      itemBuilder: (_, index) {
                        final newsItem = newsItems[index];

                        return Container(
                          margin: EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () async => await launch(newsItem.url),
                            child: Material(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // category
                                    Text(
                                      newsItem.category
                                          .toUpperCase()
                                          .replaceAll('-', ' '),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              color:
                                                  Colors.lightBlueAccent[700]),
                                    ),

                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      newsItem.title,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      newsItem.shortContent,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
