import 'package:amigoocultovirtual/src/bloc/Appbloc.dart';
import 'package:amigoocultovirtual/src/shared/colors.dart';
import 'package:amigoocultovirtual/src/shared/models/raffle.dart';
import 'package:amigoocultovirtual/src/shared/utils/alert.dart';
import 'package:amigoocultovirtual/src/shared/utils/verify_internet_connection.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class HistoricScreen extends StatefulWidget {
  @override
  _HistoricScreenState createState() => _HistoricScreenState();
}

class _HistoricScreenState extends State<HistoricScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AppBloc>(context).loadRaffles();
    VerifyInternetConnection.verifyInternet().then((value) {
      hasInternet = value;
    });
  }

  bool hasInternet = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historico"),
      ),
      body: StreamBuilder<List<Raffle>>(
          stream: BlocProvider.of<AppBloc>(context).outHistoric,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text("Nenhum sorteio a mostrar"),
              );
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return cardRaffle(snapshot.data[index]);
                  }),
            );
          }),
    );
  }

  Widget cardRaffle(Raffle raffle) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 5,
      child: ExpansionTile(
        title: Text("Sorteio: " + raffle.name),
        subtitle: Text("Data do sorteio: " +
            BlocProvider.of<AppBloc>(context).formatDate(raffle.date)),
        children: [
          participants(raffle.combinations, raffle.hasModerator),
          RaisedButton(
            onPressed: hasInternet
                ? () {
                    resendList(raffle);
                  }
                : null,
            color: AppColors.primary,
            child: Text("Reenviar Sorteio"),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  resendList(raffle) async {
    await BlocProvider.of<AppBloc>(context).sinkRaffle(raffle);

    bool response =
        await BlocProvider.of<AppBloc>(context).sendEmails(resend: true);

    if (response) {
      if (response) {
        Alert.show(
            context, "Sucesso ", " Os emails foram enviados com sucesso");
      } else {
        Alert.show(
            context, "Erro ", " Houve uma falha ao processar seu pedido");
      }
    }
  }

  participants(List<Combination> combinations, bool hasModerator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: combinations.map((e) {
          return Container(
              child: !hasModerator
                  ? Text(
                      "Participante: ${e.origin.name} ->  sorteado: ${e.friend.name}")
                  : Text("Participante: ${e.origin.name}"));
        }).toList(),
      ),
    );
  }
}
