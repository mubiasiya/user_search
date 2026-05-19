class company {
  final String name;
  final String catchphrase;
  final String bs;

  company({required this.name, required this.catchphrase, required this.bs});

  factory company.fromjson(Map<String, dynamic> json) {
    return company(
      name: json['name'] as String? ?? '',
      catchphrase: json['catchPhrase'] as String? ?? '',
      bs: json['bs'] as String? ?? '',
    );
  }
  factory company.empty() {
    return company(name: '', catchphrase: '', bs: '');
  }

  Map<String, dynamic> tojson() {
    return {'name': name, 'catchPhrase': catchphrase, 'bs': bs};
  }
}
