class Category {
  final int id;
  final String? image;
  final String? name;
  final bool? isParent;

  Category(
      {required this.id,
      required this.name,
      required this.image,
      required this.isParent});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        isParent: json['isParent']);
  }
}
