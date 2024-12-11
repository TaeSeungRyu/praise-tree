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
