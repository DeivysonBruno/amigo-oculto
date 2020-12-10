import 'package:amigoocultovirtual/src/bloc/Appbloc.dart';
import 'package:amigoocultovirtual/src/services/repository.dart';
import 'package:amigoocultovirtual/src/shared/colors.dart';
import 'package:amigoocultovirtual/src/shared/models/participant.dart';
import 'package:amigoocultovirtual/src/shared/utils/alert.dart';
import 'package:amigoocultovirtual/src/shared/utils/verify_internet_connection.dart';
import 'package:amigoocultovirtual/src/shared/validators/validate_field.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewParticipantScreen extends StatefulWidget {
  @override
  _NewParticipantScreenState createState() => _NewParticipantScreenState();
}

class _NewParticipantScreenState extends State<NewParticipantScreen> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _cepController = TextEditingController();
  var _observationController = TextEditingController(text: '');
  var _streetController = TextEditingController();
  var _numberController = TextEditingController();
  var _districtController = TextEditingController();
  var _cityController = TextEditingController();
  var _complementController = TextEditingController(text: "");
  bool load = false;
  var _formKey = GlobalKey<FormState>();
  bool radiovalue = false;

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
          title: Text("Novo Participante"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Dados pessoais",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: validateField,
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: "Nome",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Moderador:"),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: 50,
                        child: Switch(
                            value: radiovalue,
                            onChanged: (value) {
                              setState(() {
                                radiovalue = value;
                              });
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email ",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _observationController,
                    decoration: InputDecoration(
                        labelText: "Observação",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Endereço",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                      validator: validateField,
                      keyboardType: TextInputType.number,
                      controller: _cepController,
                      onEditingComplete: getAddressByCep,
                      decoration: InputDecoration(
                          labelText: "CEP",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          validator: validateField,
                          controller: _streetController,
                          decoration: InputDecoration(
                              labelText: "Rua",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          validator: validateField,
                          keyboardType: TextInputType.number,
                          controller: _numberController,
                          decoration: InputDecoration(
                              labelText: "N°",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _complementController,
                    decoration: InputDecoration(
                        labelText: "Complemento",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: validateField,
                    controller: _districtController,
                    decoration: InputDecoration(
                        labelText: "Bairro",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: validateField,
                    controller: _cityController,
                    decoration: InputDecoration(
                        labelText: "Cidade",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    onPressed: addParticipant,
                    color: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "Adicionar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addParticipant() {
    if (_formKey.currentState.validate()) {
      Address address = Address(
        city: _cityController.text,
        complement: _complementController.text,
        district: _districtController.text,
        number: _numberController.text,
        postalCode: _cepController.text,
        street: _streetController.text,
      );
      Participant participant = Participant(
          name: _nameController.text,
          email: _emailController.text,
          address: address,
          isModerator: radiovalue,
          observation: _observationController.text);
      bool resp = BlocProvider.of<AppBloc>(context).addParticipant(participant);

      if (resp) {
        setState(() {
          _nameController.clear();
          _emailController.clear();
          _cepController.clear();
          _observationController.clear();
          _streetController.clear();
          _numberController.clear();
          _districtController.clear();
          _cityController.clear();
          _complementController.clear();
          radiovalue = false;
        });
        Alert.show(context, "Feito", "Este participante foi adicionado");
      } else {
        Alert.show(context, "Algo deu errado",
            "Não foi possível adicionar esse participante, verifique se o nome ou email ja não esta cadastrado");
      }
    }
  }

  getAddressByCep() async {
    if (await VerifyInternetConnection.verifyInternet()) {
      setState(() {
        load = !load;
      });
      var response = await Repository().getAddress(_cepController.text);
      _streetController.text = response['logradouro'];
      _districtController.text = response['bairro'];
      _cityController.text = response["localidade"];
      setState(() {
        load = !load;
      });
    }
  }
}
