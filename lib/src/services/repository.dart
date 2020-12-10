import 'package:amigoocultovirtual/src/shared/network/api.dart';
import 'package:dio/dio.dart';

class Repository {
  getAddress(String cep) async {
    try {
      var response = await Api().get(
        "http://viacep.com.br/ws/$cep/json/",
      );
      return response.data;
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response);
      return e.response;
    }
  }
}
