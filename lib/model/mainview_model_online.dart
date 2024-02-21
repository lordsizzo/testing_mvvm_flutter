class GraphQLModel {
  String id;
  String title;
  String type;
  List<dynamic> genres;

  GraphQLModel({required this.title, required this.id, required this.type, required this.genres});
}