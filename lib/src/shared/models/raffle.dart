
import 'package:amigoocultovirtual/src/shared/models/participant.dart';

class Raffle{

  List<Combination> combinations;
  String name;
  double minimumValue;
  double maxValue;
  DateTime date;
  bool hasModerator;

  Raffle({this.combinations, this.name, this.minimumValue,
      this.maxValue, this.date, this.hasModerator= false});


  Raffle.fromMap(Map map){
    name = map['name'];
    minimumValue = map['minValue'];
    maxValue = map['maxValue'];
    hasModerator = map['hasModerator'];
    date = DateTime.parse(map['date']);
    combinations = (map['combinations'] as List).map((e)
    => Combination.fromMap(e)).toList();
  }
  toMap(){
    bool hasModerator = false;
    combinations.forEach((element) {
      if(element.origin.isModerator)
        hasModerator = true;
    });
    return {
      "name": this.name,
      "minValue": this.minimumValue,
      "maxValue":this.maxValue,
      "hasModerator":hasModerator,
      "date":this.date.toString(),
      "combinations": this.combinations.map((e) => e.toMap()).toList()

    };
  }

}


class Combination{


  Participant origin;
  Participant friend;

  Combination({this.origin, this.friend});

  Map toMap(){
    return{
      "origin":this.origin.toMap(),
      "friend": this.friend.toMap()
    };
  }
  Combination.fromMap(Map map){
    origin= Participant.fromMap(map['origin']);
    friend = Participant.fromMap(map['friend']);
  }

}