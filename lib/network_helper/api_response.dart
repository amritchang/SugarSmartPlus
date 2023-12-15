class APIResponse {
  String responseStatus = '';
  String message = '';
  String status = '';
  String error = '';
  String errorDescription = '';
  String refreshToken = '';
  String accessToken = '';
  String tokenType = '';
  Map<String, dynamic> detail = {};
  List<dynamic> detailArray = [];
  List<dynamic> pageList = const [];

  // Constructor with default values
  APIResponse() {
    responseStatus = '';
    message = '';
    status = '';
    error = '';
    errorDescription = '';
    refreshToken = '';
    accessToken = '';
    tokenType = '';
    detail = {};
    detailArray = [];
  }

  // Create a factory constructor to parse JSON data
  factory APIResponse.fromJson(Map<String, dynamic> json) {
    var response = APIResponse();
    if (json['responseStatus'] != null) {
      response.responseStatus = json['responseStatus'];
    }
    if (json['message'] != null) {
      response.message = json['message'];
    }
    if (json['status'] != null) {
      response.status = json['status'];
    }
    if (json['error'] != null) {
      response.error = json['error'];
    }
    if (json['error_description'] != null) {
      response.errorDescription = json['error_description'];
    }
    if (json['refresh_token'] != null) {
      response.refreshToken = json['refresh_token'];
    }
    if (json['access_token'] != null) {
      response.accessToken = json['access_token'];
    }
    if (json['token_type'] != null) {
      response.tokenType = json['token_type'];
    }
    if (json['detail'] != null) {
      if (json['detail'] is Map<String, dynamic>) {
        response.detail = json['detail'];
      }
    }
    if (json['detail'] != null) {
      if (json['detail'] is List<dynamic>) {
        response.detailArray = json['detail'];
      }
    }
    if (json['pageList'] != null) {
      response.pageList = json['pageList'];
    }
    return response;
  }
}
