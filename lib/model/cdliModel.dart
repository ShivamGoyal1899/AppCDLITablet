// To parse this JSON data, do
//
//     final cdli = cdliFromJson(jsonString);

import 'dart:convert';

List<Cdli> cdliFromJson(String str) =>
    List<Cdli>.from(json.decode(str).map((x) => Cdli.fromJson(x)));

String cdliToJson(List<Cdli> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cdli {
  DateTime date;
  String thumbnailUrl;
  String url;
  String blurbTitle;
  String theme;
  String blurb;
  String fullTitle;
  String fullInfo;

  Cdli({
    this.date,
    this.thumbnailUrl,
    this.url,
    this.blurbTitle,
    this.theme,
    this.blurb,
    this.fullTitle,
    this.fullInfo,
  });

  factory Cdli.fromJson(Map<String, dynamic> json) => Cdli(
        date: DateTime.parse(json["date"]),
        thumbnailUrl: json["thumbnail-url"],
        url: json["url"],
        blurbTitle: json["blurb-title"],
        theme: json["theme"],
        blurb: json["blurb"],
        fullTitle: json["full-title"],
        fullInfo: json["full-info"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "thumbnail-url": thumbnailUrl,
        "url": url,
        "blurb-title": blurbTitle,
        "theme": theme,
        "blurb": blurb,
        "full-title": fullTitle,
        "full-info": fullInfo,
      };
}
