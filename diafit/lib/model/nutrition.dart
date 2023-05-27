class Nutrition {
  final String name;
  final double calories;
  final double serving_size_g;
  final String id;

  Nutrition(
      {required this.name,
      required this.calories,
      required this.serving_size_g,
      required this.id});

  Nutrition.fromJson(Map json)
      : name = json['name'],
        calories = json['calories'].toDouble(),
        serving_size_g = json['serving_size_g'].toDouble(),
        id = json['id'];

  // convert dart object to json object
  Map toJson() => {
        'name': name,
        'calories': calories,
        'serving_size_g': serving_size_g,
      };
}
