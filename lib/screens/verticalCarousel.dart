import 'package:cdlitablet/model/cdliModel.dart';
import 'package:cdlitablet/screens/horizontalCarousel.dart';
import 'package:cdlitablet/screens/searchCDLI.dart';
import 'package:cdlitablet/services/dataServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VerticalCarousel extends StatefulWidget {
  VerticalCarousel({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _VerticalCarouselState createState() => _VerticalCarouselState();
}

class _VerticalCarouselState extends State<VerticalCarousel> {
  final ApiResponse dataState = ApiResponse();

  @override
  void initState() {
    dataState.getCDLI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: () {},
            tooltip: 'Switch Theme',
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (BuildContext context) {
                return SearchCDLI(title: 'CDLI tablet Search');
              }));
            },
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
            tooltip: 'Filter',
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha, color: Colors.white),
            onPressed: () {},
            tooltip: 'Sort',
          ),
          IconButton(
            icon: Icon(Icons.view_carousel, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (BuildContext context) {
                return HorizontalCarousel(title: 'CDLI tablet', index: 0);
              }));
            },
            tooltip: 'Carousel View',
          ),
        ],
      ),
      body: FutureBuilder<List<Cdli>>(
        future: dataState.getCDLI(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) => Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 0.0),
                        child: GestureDetector(
                          child:
                              Image.network(snapshot.data[index].thumbnailUrl),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) {
                              return HorizontalCarousel(
                                  title: 'CDLI tablet', index: index);
                            }));
                          },
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 10.0,
                        child: Container(
                          padding: EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  color: Colors.grey,
                                ),
                              ]),
                          child: Column(
                            children: <Widget>[
                              Text(
                                snapshot.data[index].date.day.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                DateFormat("MMM")
                                    .format(snapshot.data[index].date),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0),
                              ),
                              Text(
                                snapshot.data[index].date.year.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
