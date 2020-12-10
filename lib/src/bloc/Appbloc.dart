import 'dart:convert';
import 'dart:math';

import 'package:amigoocultovirtual/src/shared/models/participant.dart';
import 'package:amigoocultovirtual/src/shared/models/raffle.dart';
import 'package:bloc_provider/bloc_provider.dart';

import 'package:mailer/mailer.dart' as mail;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppBloc extends Bloc{

  final _participantsController = BehaviorSubject<List<Participant>>();
  Stream<List<Participant>> get outParticipantsList => _participantsController.stream;
  get sinkParticipants => _participantsController.sink.add;

  final _raffleController = BehaviorSubject<Raffle>();
  Stream get outRaffle  => _raffleController.stream;
  get sinkRaffle =>_raffleController.sink.add;

  final _raffleListController = BehaviorSubject<List<Raffle>>();
  Stream get outPendents =>_raffleListController.stream;
  get sinkListPendents =>_raffleListController.sink.add;

  final _historicListController = BehaviorSubject<List<Raffle>>();
  Stream get outHistoric=> _historicListController.stream;

  createRaffle(String name, String minValue, String maxValue, List<Combination> combinations){
     _raffleController.sink.add(
         Raffle(
         name: name,
         minimumValue: double.parse(minValue),
         maxValue: double.parse(maxValue),
         date: DateTime.now(),
         combinations: combinations
     ));
   }

   void cleanRaffle(){
    _participantsController.sink.add([]);
    _raffleController.sink.add(null);
   }

  bool  addParticipant(Participant participant){
     List<Participant> list = _participantsController.value;
    if(list == null){
      _participantsController.sink.add([]);
    }
    bool exists = false;
    list.forEach((element) {
      if(element.name == participant.name&& element.email == participant.email){
        exists = true;
      }else if(element.email == participant.email){
        exists = true;
      }
      else{
        exists = false;
      }
    });

    if(!exists){
      list.add(participant);
      _participantsController.sink.add(list);
      return true;
    }
    return false;
  }
  List raffleFriends(){
    List list = List.from(_participantsController.value);
    List friends = new List.from(list);
    list.shuffle();
    friends.shuffle();
    if(list !=null){
      List<Combination> combinations = [];
      for(Participant item in list){
        int randomFriend = Random().nextInt(friends.length);
        while(item.verifyEquals(friends[randomFriend]) ||
        verifyExistInList(combinations, item, friends[randomFriend])
        )
        {
          randomFriend = Random().nextInt(friends.length);
        }
        combinations.add(Combination(origin: item,friend: friends[randomFriend]));
        friends.remove(friends[randomFriend]);
      }
      return combinations;
    }
    return [];
  }
  bool verifyExistInList(List<Combination> list, Participant  a, Participant b){
    list.forEach((element) {
      if(element.friend.verifyEquals(a) && element.origin.verifyEquals(b)){
        return true;
      }else if(element.friend.verifyEquals(b) && element.origin.verifyEquals(a)){
       return true;
      }
    });
    return false;
  }

  Future<bool> saveHistoric()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Raffle> list = _historicListController.value;
    if(list == null){
      list = [];
    }
    list.add(_raffleController.value);
    var listTosend = list.map((e) =>jsonEncode( e.toMap())).toList();
   return await prefs.setStringList("historic",listTosend);

  }

  Future<bool> saveRaffles()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     List<Raffle> list = _raffleListController.value;
     if(list == null){
       list = [];
     }
     list.add(_raffleController.value);
     var listTosend =  list.map((e) =>jsonEncode( e.toMap())).toList();
     return await prefs.setStringList("pendents",listTosend);
  }

  Future<bool>savePendent()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Raffle> list = _raffleListController.value;
    if(list == null){
      list = [];
    }
    var listTosend = list.map((e) =>jsonEncode( e.toMap())).toList();
   return await  prefs.setStringList("pendents",listTosend);
  }

  loadRaffles()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('pendents');
    var historic = prefs.getStringList('historic');
    print(historic);
    if(historic != null){
      List<Raffle> historicList = historic.map((e) => Raffle.fromMap(jsonDecode(e))).toList();
      _historicListController.sink.add(historicList);
    }
    if(list!=null){
      List<Raffle> listRsp = list.map((e) => Raffle.fromMap(jsonDecode(e))).toList();
      _raffleListController.sink.add(listRsp);
    }
  }
  Future<bool> sendEmails({bool resend = false})async{

    String username = '';
    String password = '';
     Raffle raffle = _raffleController.value;
     if(raffle !=null){
       raffle.combinations.forEach((element) async{
         var email = createEmail(element,raffle);
         final smtpServer = gmail(username, password);
         try {
           final sendReport = await mail.send(email, smtpServer);
           print('Message sent: ' + sendReport.toString());
         } on mail.MailerException catch (e) {
           print('Message not sent.');
           print(e.message);
           for (var p in e.problems) {
             print('Problem: ${p.code}: ${p.msg}');
           }
         }
       });
     return !resend?await saveHistoric():true;
     }
     return  false;
  }


  mail.Message createEmail(Combination combination, Raffle data) {

    var body = "Ola ${combination.origin.name}\n"
        "amigo secreto "
        "${data.name}, sorteado no dia ${formatDate(data.date)} \n"
        "Com valor mínimo \$ ${data.minimumValue} e valor máximo \$${data
        .maxValue} \n"
        "O seu amigo secreto é ${combination.friend
        .name}, A seguir os dados de seu amigo\n"
        "email: ${combination.friend.email}\n "
        "Endereço: ${combination.friend.address.street} n° ${combination
        .friend.address.number}\n"
        " Bairro: ${combination.friend.address.district}\n"
        " Cidade: ${combination.friend.address.city}\n\n"
        "Atenciosamente equipe Amigo secreto Virtual";



    final message = mail.Message()
      ..from = mail.Address("virtualamigooculto@gmail.com", 'Amigo oculto virtual')
      ..recipients.add(combination.origin.email)
      ..subject = 'Sorteio Amigo oculto'
      ..text = body;

    return message;
    }


  String formatDate(DateTime date){
    return date.day.toString().padLeft(2,"0")+"/"
        ""+date.month.toString().padLeft(2,"0")+"/"+date.year.toString().padLeft(2,"0");
  }

  @override
  void dispose() {
    _historicListController.close();
    _raffleController.close();
    _raffleListController.close();
    _participantsController.close();
    // TODO: implement dispose
  }

}










