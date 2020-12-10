import 'package:amigoocultovirtual/src/bloc/Appbloc.dart';
import 'package:amigoocultovirtual/src/screens/add_participant_screen.dart';
import 'package:amigoocultovirtual/src/shared/colors.dart';
import 'package:amigoocultovirtual/src/shared/models/participant.dart';
import 'package:amigoocultovirtual/src/shared/utils/nav.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class ParticipantsListScreen extends StatefulWidget {
  @override
  _ParticipantsListScreenState createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de participantes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goTo(context, NewParticipantScreen());
        },
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<List<Participant>>(
          stream: BlocProvider.of<AppBloc>(context).outParticipantsList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return participantsList(snapshot.data);
            }
            return Center(
              child: Text("Nenhum participante adicionado"),
            );
          }),
    );
  }

  participantsList(
    List<Participant> list,
  ) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            elevation: 5,
            child: Row(
              children: [
                Flexible(
                  child: ExpansionTile(
                    title: Text(list[index].name),
                    children: [
                      Text(list[index].email),
                      Text(list[index].observation),
                      SizedBox(
                        height: 10,
                      ),
                      Text(list[index].address.street +
                          " - " +
                          list[index].address.number),
                      SizedBox(
                        height: 10,
                      ),
                      Text(list[index].address.district +
                          " - " +
                          list[index].address.city),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      dialodDelete(context).then((value) {
                        if (value) {
                          List<Participant> listaux = List.from(list);
                          listaux.removeAt(index);
                          BlocProvider.of<AppBloc>(context)
                              .sinkParticipants(listaux);
                        }
                      });
                    })
              ],
            ),
          );
        });
  }
}

Future<bool> dialodDelete(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text("Deseja Excluir?"),
        content: Text("Deseja excluir este participante"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cancelar", style: TextStyle(color: Colors.red)),
            onPressed: () {
              return Navigator.pop(context, false);
            },
          ),
          new FlatButton(
            child: new Text(
              "Ok",
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              return Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}
