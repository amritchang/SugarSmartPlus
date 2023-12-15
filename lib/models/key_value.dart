class KeyValue {
  String key;
  String value;
  final List<KeyValue> childs;

  KeyValue({
    required this.key,
    required this.value,
    this.childs = const [],
  });

  // Create a factory constructor to parse JSON data
  factory KeyValue.fromJson(Map<String, dynamic> json) {
    var response = KeyValue(key: "", value: "");
    if (json['PayeeCode'] != null && json['PayeeName'] != null) {
      response.key = json['PayeeName'] + ', ' + json['PayeeCode'];
      response.value = response.key;
    }
    return response;
  }
}
