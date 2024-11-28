class CakeModel {
  String? product;
  int? version;
  String? releaseDate;
  List<Cakes>? cakes;
  List<StaffContacts>? staffContacts;

  CakeModel({
    this.product,
    this.version,
    this.releaseDate,
    this.cakes,
    this.staffContacts,
  });

  CakeModel.fromJson(Map<String, dynamic> json) {
    product = json['product'] as String?;
    version = json['version'] as int?;
    releaseDate = json['releaseDate'] as String?;
    cakes = (json['cakes'] as List?)
        ?.map((dynamic e) => Cakes.fromJson(e as Map<String, dynamic>))
        .toList();
    staffContacts = (json['staffContacts'] as List?)
        ?.map((dynamic e) => StaffContacts.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['product'] = product;
    json['version'] = version;
    json['releaseDate'] = releaseDate;
    json['cakes'] = cakes?.map((e) => e.toJson()).toList();
    json['staffContacts'] = staffContacts?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Cakes {
  int? id;
  String? title;
  String? previewDescription;
  String? detailDescription;
  String? image;

  Cakes({
    this.id,
    this.title,
    this.previewDescription,
    this.detailDescription,
    this.image,
    required String description,
  });

  Cakes.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    previewDescription = json['previewDescription'] as String?;
    detailDescription = json['detailDescription'] as String?;
    image = json['image'] as String?;
  }

  get description => null;

  get price => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['previewDescription'] = previewDescription;
    json['detailDescription'] = detailDescription;
    json['image'] = image;
    return json;
  }
}

class StaffContacts {
  int? id;
  String? name;
  Phones? phones;
  String? role;
  String? dateOfBirth;
  List<String>? email;

  StaffContacts({
    this.id,
    this.name,
    this.phones,
    this.role,
    this.dateOfBirth,
    this.email,
  });

  StaffContacts.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    phones = (json['phones'] as Map<String, dynamic>?) != null
        ? Phones.fromJson(json['phones'] as Map<String, dynamic>)
        : null;
    role = json['role'] as String?;
    dateOfBirth = json['dateOfBirth'] as String?;
    email = (json['email'] as List?)?.map((dynamic e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['phones'] = phones?.toJson();
    json['role'] = role;
    json['dateOfBirth'] = dateOfBirth;
    json['email'] = email;
    return json;
  }
}

class Phones {
  String? home;
  String? mobile;

  Phones({
    this.home,
    this.mobile,
  });

  Phones.fromJson(Map<String, dynamic> json) {
    home = json['home'] as String?;
    mobile = json['mobile'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['home'] = home;
    json['mobile'] = mobile;
    return json;
  }
}
