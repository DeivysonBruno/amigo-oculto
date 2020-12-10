
import 'package:dio/native_imp.dart';

import 'interceptors.dart';

class Api extends DioForNative {

  Api({bool interceptor = true }) {
    options.baseUrl = "";
    interceptor?interceptors.add(DefaultInterceptor()):null;

  }
}
