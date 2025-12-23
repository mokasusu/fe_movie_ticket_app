class InvoiceResponse {
  final int? maHoaDon;
  final String? userName;
  final String? tenSuatChieu;
  final double? tongTienTruocGiam;
  final double? soTienGiam;
  final double? tongTienSauGiam;
  final String? voucher;
  final DateTime? ngayTao;
  final String? url;
  
  // Danh sách chi tiết
  final List<InvoiceSeat> gheList;
  final List<InvoiceFood> doAnList;

  InvoiceResponse({
    this.maHoaDon,
    this.userName,
    this.tenSuatChieu,
    this.tongTienTruocGiam,
    this.soTienGiam,
    this.tongTienSauGiam,
    this.voucher,
    this.ngayTao,
    this.url,
    this.gheList = const [],
    this.doAnList = const [],
  });

  double get tongTienGhe {
    return gheList.fold(0.0, (sum, seat) => sum + (seat.gia ?? 0));
  }

  double get tongTienDoAn {
    return doAnList.fold(0.0, (sum, food) => sum + (food.thanhTien ?? 0));
  }

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      maHoaDon: json['maHoaDon'] as int?,
      userName: json['userName'] as String?,
      tenSuatChieu: json['tenSuatChieu'] as String?,
      
      // Sử dụng (as num?)?.toDouble() để an toàn nếu server trả về int thay vì double
      tongTienTruocGiam: (json['tongTienTruocGiam'] as num?)?.toDouble(),
      soTienGiam: (json['soTienGiam'] as num?)?.toDouble(),
      tongTienSauGiam: (json['tongTienSauGiam'] as num?)?.toDouble(),
      
      voucher: json['voucher'] as String?,
      
      // Parse ngày tháng
      ngayTao: json['ngayTao'] != null 
          ? DateTime.tryParse(json['ngayTao']) 
          : null,
      
      url: json['url'] as String?,

      // Map danh sách ghế
      gheList: (json['gheList'] as List<dynamic>?)
              ?.map((e) => InvoiceSeat.fromJson(e))
              .toList() ?? [],

      // Map danh sách đồ ăn
      doAnList: (json['doAnList'] as List<dynamic>?)
              ?.map((e) => InvoiceFood.fromJson(e))
              .toList() ?? [],
    );
  }
}

class InvoiceSeat {
  final String? maSeatType;
  final String? tenLoaiGhe;
  final double? gia;

  InvoiceSeat({
    this.maSeatType,
    this.tenLoaiGhe,
    this.gia,
  });

  factory InvoiceSeat.fromJson(Map<String, dynamic> json) {
    return InvoiceSeat(
      maSeatType: json['maSeatType'] as String?,
      tenLoaiGhe: json['tenLoaiGhe'] as String?,
      gia: (json['gia'] as num?)?.toDouble(),
    );
  }
}

class InvoiceFood {
  final String? foodId;
  final String? tenDoAn;
  final int? soLuong;
  final double? gia;
  final double? thanhTien;

  InvoiceFood({
    this.foodId,
    this.tenDoAn,
    this.soLuong,
    this.gia,
    this.thanhTien,
  });

  factory InvoiceFood.fromJson(Map<String, dynamic> json) {
    return InvoiceFood(
      foodId: json['foodId'] as String?,
      tenDoAn: json['tenDoAn'] as String?,
      soLuong: json['soLuong'] as int?,
      gia: (json['gia'] as num?)?.toDouble(),
      thanhTien: (json['thanhTien'] as num?)?.toDouble(),
    );
  }
}