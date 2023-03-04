const String _baseUrl = "http://192.168.188.39:3000/api/";

class API {
  _YouApp youApp = _YouApp();
  static final String baseUrl = _baseUrl;
}

class _YouApp {
  _User user = _User();
}

class _User {
  final String register = "register";
  final String login = "login";

  String update(String id) => "update/$id";

  String updatePhoto(String id) => "upload-photo/$id";
}
