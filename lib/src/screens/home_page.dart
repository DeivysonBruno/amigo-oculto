import 'package:amigoocultovirtual/src/bloc/Appbloc.dart';
import 'package:amigoocultovirtual/src/screens/historic_screen.dart';
import 'package:amigoocultovirtual/src/screens/pendents_screen.dart';
import 'package:amigoocultovirtual/src/screens/raffle_screen.dart';
import 'package:amigoocultovirtual/src/shared/colors.dart';
import 'package:amigoocultovirtual/src/shared/utils/nav.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AppBloc>(context).loadRaffles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Amigo Oculto Virtual"),
      ),
      body: Container(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView.count(
                crossAxisSpacing: 15,
                mainAxisSpacing: 22,
                crossAxisCount: 3,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                children: [
                  bottomMenu("Novo Sorteio", Icons.shuffle, RaffleScreen()),
                  bottomMenu(
                      "Pendentes de envio", Icons.email, PendentsScreen()),
                  bottomMenu(
                      "Histórico de sorteios", Icons.history, HistoricScreen()),
                ]),
          ),
        ],
      )),
    );
  }

  bottomMenu(String label, IconData icon, Widget nextPage) {
    return InkWell(
      onTap: nextPage == null
          ? nextPage
          : () async {
              goTo(context, nextPage);
            },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            boxShadow: nextPage != null
                ? [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(.5))
                  ]
                : null,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: nextPage == null
                ? AppColors.primary.withOpacity(.84)
                : AppColors.primary),
        padding: EdgeInsets.only(top: 18, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            label.contains("\n")
                ? SizedBox(
                    height: 8,
                  )
                : SizedBox(
                    height: 20,
                  ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
