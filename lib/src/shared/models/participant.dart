import 'package:flutter/cupertino.dart';

class Participant {
  String name;
  String email;
  Address address;
  String observation;
  Participant friend;
  bool isModerator;

  Participant(
      {@required this.name,
      @required this.email,
      @required this.address,
      @required this.observation,
      this.isModerator = false});

  bool verifyEquals(Participant participant) {
    if (participant.name == this.name && participant.email == this.email) {
      return true;
    }
    return false;
  }

  Participant.fromMap(Map map) {
    name = map["name"];
    email = map['email'];
    observation = map['observation'];
    friend = map['friend'];
    address = Address.fromMap(map["address"]);
    isModerator = map['isModerator'];
  }

  Map toMap() {
    return {
      "name": this.name,
      "email": this.email,
      "address": this.address.toMap(),
      "observation": this.observation,
      "friend": this.friend != null ? this.friend.toMap() : null,
      "isModerator": this.isModerator
    };
  }
}

class Address {
  String street;
  String city;
  String number;
  String complement;
  String district;
  String postalCode;

  Address(
      {this.street,
      this.city,
      this.number,
      this.complement,
      this.district,
      this.postalCode});

  Address.fromMap(Map map) {
    street = map['street'];
    city = map['city'];
    number = map['number'];
    complement = map['complement'];
    district = map['district'];
    postalCode = map['postalCode'];
  }

  Map toMap() {
    return {
      "street": this.street,
      "city": this.city,
      "number": this.number,
      " complement": this.complement,
      "district": this.district,
      "postalCode": this.postalCode
    };
  }
}
