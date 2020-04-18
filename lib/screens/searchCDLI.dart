import 'package:cdlitablet/screens/verticalCarousel.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

class SearchCDLI extends StatefulWidget {
  SearchCDLI({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _SearchCDLIState createState() => _SearchCDLIState();
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class _SearchCDLIState extends State<SearchCDLI> {
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length * 2, (int index) {
      return Post(
        "Title: $search $index",
        "Description: $search $index",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          PopupMenuButton<Themes>(
            captureInheritedThemes: true,
            padding: EdgeInsets.all(0),
            color: Colors.white,
            offset: Offset.fromDirection(2.2, 100),
            icon: Icon(Icons.lightbulb_outline),
            tooltip: 'Switch Theme',
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            itemBuilder: (_) => <PopupMenuEntry<Themes>>[
              PopupMenuItem<Themes>(
                enabled: false,
                child: Center(
                  child: Text(
                    'Themes',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
              PopupMenuDivider(height: 0.0),
              PopupMenuItem<Themes>(
                value: Themes.Dark,
                child: ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text('Light'),
                ),
              ),
              PopupMenuDivider(height: 0.0),
              PopupMenuItem<Themes>(
                value: Themes.Light,
                child: ListTile(
                  leading: Icon(Icons.brightness_3),
                  title: Text('Dark'),
                ),
              ),
              PopupMenuDivider(height: 0.0),
              PopupMenuItem<Themes>(
                value: Themes.System,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('System'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            crossAxisCount: 2,
            hintText: 'Search Artifacts',
            placeHolder: Center(
                child: Image.asset(
              'assets/images/logo.png',
              width: 200,
            )),
            onSearch: search,
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(
                  post.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  post.description,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
            cancellationWidget: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            searchBarStyle: SearchBarStyle(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
