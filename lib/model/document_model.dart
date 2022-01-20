
class Document {
  late String document_number;
  String document_type = "Cedula de Identidad";
  String api_key = "7e9ef835066a907e4264caa94389a8695775bb94a8c66bf459ce423faab15c0f";
  late String user;
  late String imei;

  Document({required this.document_number, required this.user});

  Map<String, dynamic> toJson(){
    final data = Map<String, dynamic>();
    data['document_number'] = document_number;
    data['document_type'] = document_type;
    data['api_key'] = api_key;
    data['user'] = user;
    return data;
  }

}