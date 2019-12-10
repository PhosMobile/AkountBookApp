import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  final _url = "http://127.0.0.1:8000/api/";

  postData(data, apiUrl) async {
    var fulUrl = "http://10.0.2.2:8000/api/" + apiUrl;
    return await http.post(fulUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fulUrl = _url + apiUrl;
    return await http.get(fulUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'accept': 'application/json',
      };
}
