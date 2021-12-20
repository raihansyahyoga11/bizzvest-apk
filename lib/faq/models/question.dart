class Question {
  String model;
  int pk;
  Fields? fields;

  Question({required this.model, required this.pk, required this.fields});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        model: json['model'],
        pk: json['pk'],
        fields : json['fields'] != null ? new Fields.fromJson(json['fields']) : null,
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['pk'] = this.pk;
    if (this.fields != null) {
      data['fields'] = this.fields?.toJson();
    }
    return data;
  }
}

class Fields {
  String nama;
  String pertanyaan;

  Fields({required this.nama, required this.pertanyaan});

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
        nama: json['nama'],
        pertanyaan: json['pertanyaan'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;
    data['pertanyaan'] = this.pertanyaan;
    return data;
  }
}