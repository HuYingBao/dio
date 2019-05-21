import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

main() async {
  var dio = Dio(BaseOptions(headers: {
    HttpHeaders.userAgentHeader:
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36",
    HttpHeaders.acceptHeader: "*/*",
  }));

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.findProxy = (uri) {
      //proxy all request to localhost:8888
      return "PROXY localhost:8888";
    };
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  };

  var cookieJar = PersistCookieJar();

  dio.interceptors..add(LogInterceptor())..add(CookieManager(cookieJar));
  Response r;
  String refer =
      "https://sso.bytedance.com/user/login?next=/oauth2/authorize%3Fredirect_uri%3Dhttps%253A%252F%252Fpeople.bytedance.net%252Fauth%252Fcallback_sso%252F%26access_type%3Donline%26response_type%3Dcode%26scope%3Dread%26client_id%3Dc931daa3075828cf2317%26state%3DeyJuZXh0IjoiL29hdXRoMmNhbGxiYWNrIiwicGxhdGZvcm0iOiJnb29nbGUiLCJuZXh0X3VybCI6Ii8ifQ%253D%253D";
  r = await dio.get(refer);
//  try {
//    r = await dio.get("https://sso.bytedance.com/api/v1/be/user");
//  }catch(e){}
//  var cookies=cookieJar.loadForRequest(Uri.parse("https://sso.bytedance.com/"));
//  print(cookies);
  r = await dio.post(
    "https://sso.bytedance.com/api/v1/be/login",
    //options: Options()
    data: {
      "username": "duwen.x",
      "password": "dW@19901125",
    },
  );

  r = await dio.post("https://sso.bytedance.com/api/v1/be/verify", data: {
    "token": "615143",
  });

  if(r.data["state"]=="error"){
    print(r.data["msg"]);
  }
  
  r=await dio.get("https://sso.bytedance.com/oauth2/authorize?redirect_uri=https%3A%2F%2Fpeople.bytedance.net%2Fauth%2Fcallback_sso%2F&access_type=online&response_type=code&scope=read&client_id=c931daa3075828cf2317&state=eyJuZXh0IjoiL29hdXRoMmNhbGxiYWNrIiwicGxhdGZvcm0iOiJnb29nbGUiLCJuZXh0X3VybCI6Ii8ifQ%3D%3D");

  print(r);
}
