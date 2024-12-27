///위치 정보를 담는 VO
class MarkPositionVo {
  double x;
  double y;
  double width;
  double height;

  MarkPositionVo({this.x = 0, this.y = 0, this.width = 0, this.height = 0});

  factory MarkPositionVo.fromJson(Map<String, dynamic> json) {
    return MarkPositionVo(
      x: json['x'] | 0,
      y: json['y'] | 0,
      width: json['width'] | 0,
      height: json['height'] | 0,
    );
  }
}

class TreeVo {
  List<MarkPositionVo> positionList = [];
  String finishedDate = "";
  TreeVo({this.positionList = const [], this.finishedDate = ""});

  factory TreeVo.fromJson(Map<String, dynamic> json) {
    return TreeVo(
      positionList: (json['positionList'] as List)
          .map((e) => MarkPositionVo.fromJson(e))
          .toList() ?? [],
      finishedDate: json['finishedDate'] ?? "",
    );
  }

}