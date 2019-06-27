class Source {
  final int id;
  final String domain;
  final String date;
  Source(this.id, this.domain, this.date);
  Source.fromJson(Map<String, dynamic> json)
  : id = json["id"],
  domain = json["domain"],
  date = json["lastCrawled"];
}