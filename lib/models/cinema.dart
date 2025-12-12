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
}