class Player {
  int? id;
  String name;
  int rating;
  int gamesPlayed;
  int gamesWon;
  bool isLiked;

  Player({
    this.id,
    required this.name,
    required this.rating,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.isLiked = false
  });

  double getWinRate(){
    return double.parse((gamesWon/gamesPlayed).toStringAsFixed(2)).isNaN ? 0 : double.parse((gamesWon/gamesPlayed).toStringAsFixed(2)); //Error divide by 0
  }

  factory Player.fromMap(Map<String, dynamic> map){
    return Player(
      id: map['id'],
      name: map['name'],
      rating: map['rating'],
      gamesPlayed: map['gamesPlayed'] ?? 0,
      gamesWon: map['gamesWon'] ?? 0,
    );
  }

  Map<String, dynamic> toMap(){
    return({
      "id": id,
      "name": name,
      "rating": rating,
      "gamesPlayed": gamesPlayed,
      "gamesWon": gamesWon,
      "isLiked": isLiked,
    });
  }
}