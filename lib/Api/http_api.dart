import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  final _url = "http://127.0.0.1:8000/api/";

  PostData(data, apiUrl) async {
    var ful_url = "http://10.0.2.2:8000/api/" + apiUrl;
    return await http.post(ful_url,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var ful_url = _url + apiUrl;
    return await http.get(ful_url, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'accept': 'application/json',
      };
}
