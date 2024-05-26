import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class JenisTransaksiPage extends StatefulWidget {
  const JenisTransaksiPage({Key? key}) : super(key: key);

  @override
  _JenisTransaksiPageState createState() => _JenisTransaksiPageState();
}

class _JenisTransaksiPageState extends State<JenisTransaksiPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<JenisTransaksi> jenisTransaksiList = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getJenisTransaksi();
  }

  Future<void> getJenisTransaksi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final jenisTransaksiData = responseData['data']['jenistransaksi'];
        if (jenisTransaksiData is List) {
          jenisTransaksiList = jenisTransaksiData
              .map((jenisTransaksiJson) => JenisTransaksi.fromJson({
                    "id": jenisTransaksiJson["id"],
                    "trx_name": jenisTransaksiJson["trx_name"],
                  }))
              .toList();
        } else {
          throw Exception('Jenis Transaksi Tidak Ditemukan');
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Terjadi kesalahan saat mengambil data jenis transaksi.',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8989),
        title: const Text(
          'Master Jenis Transaksi',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/homepage');
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jenisTransaksiList.isEmpty
              ? const Center(child: Text('Jenis Transaksi tidak ditemukan'))
              : ListView.builder(
                  itemCount: jenisTransaksiList.length,
                  itemBuilder: (context, index) {
                    final jenis = jenisTransaksiList[index];
                    return buildDetailCard(jenis.id, jenis.trxName ?? '');
                  },
                ),
    );
  }

  Widget buildDetailCard(int? id, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Text('ID: $id'),
        ),
      ),
    );
  }
}

class JenisTransaksi {
  int? id;
  String? trxName;

  JenisTransaksi({
    this.id,
    this.trxName,
  });

  factory JenisTransaksi.fromJson(Map<String, dynamic> json) {
    return JenisTransaksi(
      id: json['id'],
      trxName: json['trx_name'],
    );
  }
}
