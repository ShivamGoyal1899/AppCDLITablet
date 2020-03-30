import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cdlitablet/model/cdliModel.dart';
import 'package:cdlitablet/screens/verticalCarousel.dart';
import 'package:cdlitablet/services/dataServices.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class HorizontalCarousel extends StatefulWidget {
  HorizontalCarousel({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HorizontalCarouselState createState() => _HorizontalCarouselState();
}

class _HorizontalCarouselState extends State<HorizontalCarousel> {
  final ApiResponse dataState = ApiResponse();
  int _current;
  String _currentUri;

  @override
  void initState() {
    dataState.getCDLI();
    _current = 0;
    _currentUri =
        'https://cdli.ucla.edu/dl/daily_tablets/RSM7-521c91d137921_thumbnail.jpg';
    super.initState();
  }

  Future<void> _downloadImageFromUrl() async {
    Flushbar(
      title: "CDLI Tablet",
      message: "Downloading Artifact Image...",
      duration: Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 8,
      flushbarPosition: FlushbarPosition.BOTTOM,
      showProgressIndicator: false,
    )..show(context);

    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(_currentUri,
          destination: AndroidDestinationType.custom(directory: 'CDLITablet'));
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var path = await ImageDownloader.findPath(imageId);

      Flushbar(
        title: "CDLI Tablet",
        message: "Artifact Image is saved to Gallery!",
        duration: Duration(seconds: 3),
        flushbarStyle: FlushbarStyle.FLOATING,
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
        flushbarPosition: FlushbarPosition.BOTTOM,
        showProgressIndicator: false,
        mainButton: FlatButton(
          onPressed: () async {
            await ImageDownloader.open(path);
          },
          child: Text(
            "VIEW",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      )..show(context);
    } on PlatformException catch (e) {
      print('_downloadImageFromUrl error: $e');
    }
  }

  Future<void> _shareImageFromUrl() async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(_currentUri));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('CDLI Tablet', 'cdli.jpg', bytes, 'image/jpg',
          text:
              '﻿I saw this entry on the CDLI tablet app and wanted to share it with you:\n\n\"Debt-note and its sealed envelope dating to the Old Assyrian period; National Museums Scotland, Edinburgh; NMS A.1909.586.\"\n\nVisit this page on the web: https://cdli.ucla.edu/cdlitablet/showcase?date=2020-03-30\n\nInformation about the iPad and Android apps:\nhttps://cdli.ucla.edu/?q=cdli-tablet');
    } catch (e) {
      print('_shareImageFromUrl error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download, color: Colors.white),
            onPressed: () async => await _downloadImageFromUrl(),
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () async => await _shareImageFromUrl(),
          ),
          IconButton(
            icon: Icon(Icons.apps, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (BuildContext context) {
                return VerticalCarousel(title: 'CDLI tablet');
              }));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Cdli>>(
        future: dataState.getCDLI(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? SlidingUpPanel(
                  parallaxEnabled: true,
                  parallaxOffset: 0.4,
                  renderPanelSheet: false,
                  panelSnapping: true,
                  backdropEnabled: false,
                  slideDirection: SlideDirection.UP,
                  panel: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Colors.grey,
                          ),
                        ]),
                    margin: const EdgeInsets.all(24.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0)),
                            ),
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    24.0, 28.0, 24.0, 28.0),
                                child: Text(
                                  snapshot.data[_current].blurbTitle,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Html(
                                      data: snapshot.data[_current].blurb,
                                      defaultTextStyle:
                                          TextStyle(fontSize: 10.0),
                                    ),
                                    Divider(
                                      height: 15.0,
                                      thickness: 1.0,
                                      color: Colors.black,
                                    ),
                                    Html(
                                      data: snapshot.data[_current].fullInfo,
                                      defaultTextStyle:
                                          TextStyle(fontSize: 10.0),
                                      renderNewlines: false,
                                      onLinkTap: (url) async {
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                    ),
                                    Divider(
                                      height: 15.0,
                                      thickness: 1.0,
                                      color: Colors.black,
                                    ),
                                    Html(
                                      data: 'Published on: ' +
                                          DateFormat("d MMMM y").format(
                                              snapshot.data[_current].date),
                                      defaultTextStyle:
                                          TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  collapsed: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0)),
                    ),
                    margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                    child: Center(
                      child: Text(
                        snapshot.data[_current].blurbTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  body: CarouselSlider.builder(
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                        // TODO: Change thumbnailUrl -> url
                        _currentUri = snapshot.data[index].thumbnailUrl;
                      });
                    },
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => PhotoView(
                      // TODO: Change thumbnailUrl -> url
                      imageProvider:
                          NetworkImage(snapshot.data[index].thumbnailUrl),
                      backgroundDecoration: BoxDecoration(color: Colors.black),
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
