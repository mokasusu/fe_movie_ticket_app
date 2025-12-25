import 'package:flutter/material.dart';
import '../../../models/voucher.dart';
import '../../../services/api/voucher_service.dart';

class VoucherFormDialog extends StatefulWidget {
  final Voucher? voucher;
  final VoidCallback onSuccess;

  const VoucherFormDialog({
    super.key,
    this.voucher,
    required this.onSuccess,
  });

  @override
  State<VoucherFormDialog> createState() => _VoucherFormDialogState();
}

class _VoucherFormDialogState extends State<VoucherFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController maCtrl;
  late TextEditingController moTaCtrl;
  late TextEditingController giaTriCtrl;
  late TextEditingController soLuongCtrl;

  DiscountType _loai = DiscountType.PERCENTAGE;
  DateTime _ngayHetHan = DateTime.now().add(const Duration(days: 30));
  bool _trangThai = true;

  @override
  void initState() {
    super.initState();
    final v = widget.voucher;

    maCtrl = TextEditingController(text: v?.maGiamGia ?? "");
    moTaCtrl = TextEditingController(text: v?.moTa ?? "");
    giaTriCtrl = TextEditingController(text: v?.giaTriGiam.toString() ?? "");
    soLuongCtrl = TextEditingController(text: v?.soLuong.toString() ?? "");
    _loai = v?.loaiGiamGia ?? DiscountType.PERCENTAGE;
    _trangThai = v?.trangThai ?? true;
    _ngayHetHan = v?.ngayHetHan ?? _ngayHetHan;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.voucher == null ? "Tạo Voucher" : "Cập nhật Voucher"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.voucher == null)
                TextFormField(
                  controller: maCtrl,
                  decoration: const InputDecoration(labelText: "Mã giảm giá"),
                  validator: (v) => v!.isEmpty ? "Không được trống" : null,
                ),
              TextFormField(
                controller: moTaCtrl,
                decoration: const InputDecoration(labelText: "Mô tả"),
              ),
              TextFormField(
                controller: giaTriCtrl,
                decoration: const InputDecoration(labelText: "Giá trị giảm"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField(
                value: _loai,
                items: DiscountType.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _loai = v!),
              ),
              TextFormField(
                controller: soLuongCtrl,
                decoration: const InputDecoration(labelText: "Số lượng"),
                keyboardType: TextInputType.number,
              ),
              if (widget.voucher != null)
                SwitchListTile(
                  value: _trangThai,
                  onChanged: (v) => setState(() => _trangThai = v),
                  title: const Text("Kích hoạt"),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Huỷ"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Lưu"),
        ),
      ],
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.voucher == null) {
      await VoucherService.createVoucher(
        maGiamGia: maCtrl.text,
        moTa: moTaCtrl.text,
        giaTriGiam: double.parse(giaTriCtrl.text),
        loaiGiamGia: _loai,
        ngayHetHan: _ngayHetHan,
        soLuong: int.parse(soLuongCtrl.text),
      );
    } else {
      await VoucherService.updateVoucher(
        widget.voucher!.maGiamGia,
        moTa: moTaCtrl.text,
        giaTriGiam: double.parse(giaTriCtrl.text),
        loaiGiamGia: _loai,
        ngayHetHan: _ngayHetHan,
        soLuong: int.parse(soLuongCtrl.text),
        trangThai: _trangThai,
      );
    }

    widget.onSuccess();
    Navigator.pop(context);
  }
}
