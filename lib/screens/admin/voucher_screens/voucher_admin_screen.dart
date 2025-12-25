import 'package:flutter/material.dart';
import '../../../models/voucher.dart';
import '../../../services/api/voucher_service.dart';
import '../../../screens/admin/voucher_screens/VoucherFormDialog.dart';

class VoucherAdminScreen extends StatefulWidget {
  const VoucherAdminScreen({super.key});

  @override
  State<VoucherAdminScreen> createState() => _VoucherAdminScreenState();
}

class _VoucherAdminScreenState extends State<VoucherAdminScreen> {
  late Future<List<Voucher>> _futureVouchers;

  @override
  void initState() {
    super.initState();
    _loadVouchers();
  }

  void _loadVouchers() {
    _futureVouchers = VoucherService.fetchVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Voucher"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openVoucherForm(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Voucher>>(
        future: _futureVouchers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có voucher"));
          }

          final vouchers = snapshot.data!;
          return ListView.builder(
            itemCount: vouchers.length,
            itemBuilder: (_, index) {
              final v = vouchers[index];
              return _voucherItem(v);
            },
          );
        },
      ),
    );
  }

  Widget _voucherItem(Voucher v) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          v.maGiamGia,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v.moTa),
            Text("Giảm: ${v.displayValue}"),
            Text("HSD: ${v.ngayHetHan ?? "Không"}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _openVoucherForm(voucher: v),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteVoucher(v.maGiamGia),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // DELETE
  // =========================
  void _deleteVoucher(String maGiamGia) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Xoá voucher này?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Huỷ")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Xoá")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await VoucherService.deleteVoucher(maGiamGia);
      if (success) {
        setState(_loadVouchers);
      }
    }
  }

  // =========================
  // FORM CREATE / UPDATE
  // =========================
  void _openVoucherForm({Voucher? voucher}) {
    showDialog(
      context: context,
      builder: (_) => VoucherFormDialog(
        voucher: voucher,
        onSuccess: () => setState(_loadVouchers),
      ),
    );
  }
}
