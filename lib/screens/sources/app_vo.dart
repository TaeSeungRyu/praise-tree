class AppVo {
  String name;
  String description;
  String url;
  String imageUrl;

  AppVo(
      {this.name = "",
      this.description = "",
      this.url = "",
      this.imageUrl = ""});

  factory AppVo.fromJson(Map<String, dynamic> json) {
    return AppVo(
        name: json['name'],
        description: json['description'],
        url: json['url'],
        imageUrl: json['imageUrl']);
  }
}

class MarkPositionVo {
  double x;
  double y;
  MarkPositionVo({this.x = 0, this.y = 0});
  factory MarkPositionVo.fromJson(Map<String, dynamic> json) {
    return MarkPositionVo(
      x: json['x'] | 0,
      y: json['y'] | 0,
    );
  }
}
