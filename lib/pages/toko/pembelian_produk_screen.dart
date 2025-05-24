import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pascapanen_mobile/model/produk.dart';

class PurchaseFormPage extends StatefulWidget {
  final Produk produk;

  const PurchaseFormPage({super.key, required this.produk});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  int jumlah = 0;
  late int stok;
  final _formatRupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    stok = widget.produk.stok;
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  double get total => jumlah * widget.produk.harga;

  void _submitTransaksi() {
    if (_formKey.currentState!.validate()) {
      // Kirim data ke backend (buat service transaksi)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi berhasil (simulasi)")),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pembelian'),
        backgroundColor: const Color(0xFF166534),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(produk.namaProduk,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Harga: ${_formatRupiah.format(produk.harga)}'),
              Text('Stok tersedia: $stok'),
              const SizedBox(height: 20),

              // Input jumlah beli
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Pembelian'),
                validator: (value) {
                  final val = int.tryParse(value ?? '');
                  if (val == null || val <= 0) return 'Masukkan jumlah yang valid';
                  if (val > stok) return 'Jumlah melebihi stok';
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    jumlah = int.tryParse(val) ?? 0;
                  });
                },
              ),

              const SizedBox(height: 20),
              Text('Total Harga: ${_formatRupiah.format(total)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitTransaksi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Bayar Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
