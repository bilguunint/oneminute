class Source {
  final String id;
  final String name;
  Source(this.id, this.name);
  Source.fromJson(Map<String, dynamic> json)
  : id = json["id"],
  name = json["name"];
}