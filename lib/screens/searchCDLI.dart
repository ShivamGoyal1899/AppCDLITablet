import 'package:cdlitablet/screens/search_bar.dart';
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
          IconButton(
            icon: Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: () {},
            tooltip: 'Switch Theme',
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
