import 'package:amigoocultovirtual/src/bloc/Appbloc.dart';
import 'package:amigoocultovirtual/src/screens/participants_list.dart';
import 'package:amigoocultovirtual/src/shared/colors.dart';
import 'package:amigoocultovirtual/src/shared/models/participant.dart';
import 'package:amigoocultovirtual/src/shared/models/raffle.dart';
import 'package:amigoocultovirtual/src/shared/utils/alert.dart';
import 'package:amigoocultovirtual/src/shared/utils/nav.dart';
import 'package:amigoocultovirtual/src/shared/utils/verify_internet_connection.dart';
import 'package:amigoocultovirtual/src/shared/validators/validate_field.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RaffleScreen extends StatefulWidget {
  @override
  _RaffleScreenState createState() => _RaffleScreenState();
}

class _RaffleScreenState extends State<RaffleScreen> {
  var _nameController = TextEditingController();
  var _minValueController = TextEditingController();
  var _maxValueController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  bool hasInternet = true;
  bool load = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: load,
      opacity: 0.5,
      color: Colors.black,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.primary),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Novo sorteio"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    validator: validateField,
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: "Nome do sorteio",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _minValueController,
                    validator: validateField,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        labelText: "valor minimo ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: validateField,
                    controller: _maxValueController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),

                    decoration: InputDecoration(

                        labelText: "valor maximo",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Este Amigo secreto deve conter no mínimo 4 participantes",
                    textAlign: TextAlign.center,

                  ),
                  SizedBox(
                    height: 20,
                  ),

                  StreamBuilder<List<Participant>>(
                      stream: BlocProvider.of<AppBloc>(context).outParticipantsList,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return FlatButton(
                              onPressed: () {
                                goTo(context, ParticipantsListScreen());
                              },
                              child: Text(
                                "Adicionar participantes +",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline),
                              ));
                        }
                        return Column(
                          children: [
                            Text("Quantidades de paticipantes:"
                                " ${snapshot.data.length}"),
                            FlatButton(
                                onPressed: () {
                                  goTo(context, ParticipantsListScreen());
                                },
                                child: Text(
                                  "Adicionar Mais participantes",
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        );
                      }),
                  StreamBuilder<List<Participant>>(
                      stream: BlocProvider.of<AppBloc>(context).outParticipantsList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return RaisedButton(
                            onPressed: snapshot.data.length >= 4
                                ?raffleFriends
                                : null,
                            child: Text("Realizar sorteio"),
                            color: AppColors.primary,
                          );
                        }
                        return RaisedButton(
                          onPressed: null,
                          child: Text("Realizar sorteio"),
                        );
                      }),

              SizedBox(height: 30,),

              StreamBuilder<Raffle>(
                  stream: BlocProvider
                      .of<AppBloc>(context)
                      .outRaffle,
                  builder: (context, snapshot) {
                    return RaisedButton(
                        color: AppColors.primary,
                        child: Text("Enviar sorteio por Email"
                          , style: TextStyle(color: Colors.white),),
                        onPressed: snapshot.hasData?hasInternet ? sendRaffleForEmail : null:null);
                  }
              ),

                  StreamBuilder<Raffle>(
                      stream: BlocProvider
                          .of<AppBloc>(context)
                          .outRaffle,
                      builder: (context, snapshot) {
                        return RaisedButton(
                            color: AppColors.primary,
                            child: Text("Enviar Depois"
                              , style: TextStyle(color: Colors.white),),
                            onPressed: snapshot.hasData?savePendentRaffle:null)
                        ;
                      }
                  ),
                  SizedBox(height: 30,),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  savePendentRaffle() async{
    setState(() {
      load = !load;
    });

    var response = await BlocProvider.of<AppBloc>(context).saveRaffles();
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      load = !load;
    });

    if(response){
      Alert.show(context, "Sucesso", "Sorteio foi salvo para envio posterior");
      _nameController.clear();
      _minValueController.clear();
      _maxValueController.clear();
      BlocProvider.of<AppBloc>(context).cleanRaffle();
    }else {
      Alert.show(context, "Erro "," Houve uma falha ao processar seu pedido");

    }

  }

  sendRaffleForEmail()async{
    setState(() {
      load = !load;
    });
   var response =  await BlocProvider.of<AppBloc>(context).sendEmails();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      load = !load;
    });

   if(response){
     Alert.show(context, "Emails Enviados "," Emails enviados com sucesso");
     _nameController.clear();
     _minValueController.clear();
     _maxValueController.clear();
     BlocProvider.of<AppBloc>(context).cleanRaffle();
   }else {
     Alert.show(context, "Erro "," Houve uma falha ao processar seu pedido");
   }

  }

  raffleFriends() async {
    VerifyInternetConnection.verifyInternet().then((value) {hasInternet= value;});

    if (_formKey.currentState.validate()) {

      setState(() {
        load = !load;
      });
      await Future.delayed(Duration(seconds: 1));
      List list = BlocProvider.of<AppBloc>(context)
          .raffleFriends();

      BlocProvider.of<AppBloc>(context)
          .createRaffle(
          _nameController.text,
          _minValueController.text,
          _maxValueController.text,
          list);

      setState(() {
        load = !load;
      });
    }
  }

}
