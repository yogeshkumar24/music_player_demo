class Track {
  String track;
  String name;

  Track({this.track, this.name});

  Track.fromJson(Map<String, dynamic> json) {
    track = json['track'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['track'] = this.track;
    data['name'] = this.name;
    return data;
  }
}
