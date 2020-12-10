import 'package:amigoocultovirtual/src/bloc/Appbloc.dart';
import 'package:amigoocultovirtual/src/shared/colors.dart';
import 'package:amigoocultovirtual/src/shared/models/raffle.dart';
import 'package:amigoocultovirtual/src/shared/utils/alert.dart';
import 'package:amigoocultovirtual/src/shared/utils/verify_internet_connection.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class PendentsScreen extends StatefulWidget {
  @override
  _PendentsScreenState createState() => _PendentsScreenState();
}

class _PendentsScreenState extends State<PendentsScreen> {

  bool hasInternet = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VerifyInternetConnection.verifyInternet().then((value) {
      hasInternet = value;
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text("Pendentes de envio"),),

      body: StreamBuilder<List<Raffle>>(
          stream: BlocProvider.of<AppBloc>(context).outPendents,
          builder: (context, snapshot) {

            if(!snapshot.hasData) return Center(child: Text("Nenhum sorteio a mostrar"),);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: list(snapshot.data),
            );
          }
      ),
    );
  }


  list(List<Raffle> list){
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            elevation: 5,
            child: ExpansionTile(
              title: Text("Sorteio: "+list[index].name),
              subtitle: Text("Data do sorteio: "+ BlocProvider.of<AppBloc>(context).formatDate(list[index].date)),
              children: [
                participants(list[index].combinations,list[index].hasModerator),
                RaisedButton(onPressed: hasInternet?(){
                  sendList ( list, index);
                }:null,
                  color: AppColors.primary,
                  child: Text("Enviar Sorteio"),
                ),
                SizedBox(height: 10,),

              ],
            ),
          );
        });
  }




  sendList (List list, index)async{

    await BlocProvider.of<AppBloc>(context).sinkRaffle(list[index]);
    list.removeAt(index);
    await BlocProvider.of<AppBloc>(context).sinkListPendents(list);
    await BlocProvider.of<AppBloc>(context).savePendent();
    bool response = await BlocProvider.of<AppBloc>(context).sendEmails();
      if(response){
        Alert.show(context, "Sucesso "," Os emails foram enviados com sucesso");

      }else {
        Alert.show(context, "Erro "," Houve uma falha ao processar seu pedido");
      }

  }

  participants(List<Combination> combinations, bool hasModerator){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: combinations.map((e) {
          return Container(
              child: !hasModerator?Text ("Participante: ${e.origin.name} ->  sorteado: ${e.friend.name}"
              ):
              Text ("Participante: ${e.origin.name}"

              )
          );
        }
        ).toList(),
      ),
    );

  }
}
