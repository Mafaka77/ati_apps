class DocumentModel {
  String? id;
  String? title;
  String? description;
  String? fileUrl;

  DocumentModel({this.id, this.title, this.description, this.fileUrl});
  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      fileUrl: map['fileUrl'],
    );
  }
  static List<DocumentModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => DocumentModel.fromMap(e)).toList();
  }
}
