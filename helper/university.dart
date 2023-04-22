class University {
  University({this.name, this.type, this.score, this.miasto});
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] as String,
      type: json['type'] as String,
      score: int.tryParse(json['score'] as String),
      miasto: json['miasto'] as String,
    );
  }
  String? name;
  String? type;
  int? score;
  String? miasto;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'score': score,
      'miasto': miasto,
    };
  }

  @override
  String toString() {
    return '$name, $type, $score, $miasto';
  }
}

List<University> universityList = [
  University(
    name: 'Politechnika Poznańska',
    type: 'uczelnia',
    score: 0,
    miasto: 'Poznań',
  ),
  University(
    name: 'UAM',
    type: 'uczelnia',
    score: 0,
    miasto: 'Poznań',
  ),
  University(
    name: 'CDV',
    type: 'uczelnia',
    score: 0,
    miasto: 'Poznań',
  ),
  University(
    name: 'Politechnika Gdańska',
    type: 'uczelnia',
    score: 0,
    miasto: 'Gdańsk',
  ),
];
