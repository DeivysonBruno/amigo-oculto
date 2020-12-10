import 'package:dio/dio.dart';


class DefaultInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {

    options.connectTimeout = 15000;
    options.receiveTimeout = 15000;
  }

  @override
  onResponse(Response response) async{
    return  response;
  }

  @override
  onError(DioError e) async{
    return e;
  }

}

