class Cinema {
  final int maRap;
  final String tenRap;
  final String diaDiem;

  Cinema({
    required this.maRap,
    required this.tenRap,
    required this.diaDiem,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      maRap: json['maRap'],
      tenRap: json['tenRap'],
      diaDiem: json['diaDiem'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cinema && other.maRap == maRap;
  }

  @override
  int get hashCode => maRap.hashCode;
}
