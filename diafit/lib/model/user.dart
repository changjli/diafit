class User {
  final String? id;
  final String? name;
  final String email;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  final String? address;

  User({
    this.id,
    this.name,
    required this.email,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.address,
  });

  // convert json object to dart object
  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        gender = json['gender'],
        age = json['age'],
        weight = double.parse(json['weight']),
        height = double.parse(json['height']),
        address = json['address'];

  // convert dart object to json object
  Map toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'address': address,
      };
}
