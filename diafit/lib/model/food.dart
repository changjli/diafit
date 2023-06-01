class Food {
  final String name;
  final double serving_size;
  final int price;
  final DateTime date;
  final double calories;
  final double proteins;
  final double fats;
  final double carbs;
  // final String id;

  Food({
    required this.name,
    required this.serving_size,
    required this.price,
    required this.date,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  Food.fromJson(Map json, String price, String date)
      : name = json['name'],
        serving_size = json['serving_size_g'],
        price = int.parse(price),
        date = DateTime.parse(date),
        calories = json['calories'],
        proteins = json['protein_g'],
        fats = json['fat_total_g'],
        carbs = json['carbohydrates_total_g'];

  Food.fromJson2(Map json)
      : name = json['name'],
        serving_size = json['serving_size_g'],
        price = json['price'],
        date = json['date'],
        calories = json['calories'],
        proteins = json['protein_g'],
        fats = json['fat_total_g'],
        carbs = json['carbohydrates_total_g'];

  // convert dart object to json object
  Map toJson() => {
        'name': name,
        'serving_size': serving_size,
        'price': price,
        'date': date,
        'calories': calories,
        'proteins': proteins,
        'fats': fats,
        'carbs': carbs,
      };
}
