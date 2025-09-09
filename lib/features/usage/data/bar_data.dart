class BarVal {
  final int x;
  final double y;

  BarVal({required this.x, required this.y});
}

class BarData {
  final double instaUse;
  final double twitUse;
  final double faceUse;

  BarData({
    required this.instaUse,
    required this.twitUse,
    required this.faceUse,
  });

  List<BarVal> get barDataList => [
        BarVal(x: 0, y: instaUse),
        BarVal(x: 1, y: twitUse),
        BarVal(x: 2, y: faceUse),
      ];
}
