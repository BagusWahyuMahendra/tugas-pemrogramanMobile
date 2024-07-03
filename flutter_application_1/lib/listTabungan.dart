import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ListTabunganPage extends StatefulWidget {
  const ListTabunganPage({Key? key}) : super(key: key);

  @override
  _ListTabunganPageState createState() => _ListTabunganPageState();
}

class _ListTabunganPageState extends State<ListTabunganPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late int anggotaId = 0;

  List<Tabungan> tabunganList = [];
  bool isLoading = false;
  int currentPage = 1;
  int itemsPerPage = 10;

  final Map<int, String> transactionTypes = {
    1: 'Saldo Awal',
    2: 'Simpanan',
    3: 'Penarikan',
    4: 'Bunga Simpanan',
    5: 'Koreksi Penambahan',
    6: 'Koreksi Pengurangan',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      anggotaId = args as int;
      getTabunganMember();
    }
  }

  Future<void> getTabunganMember() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$anggotaId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tabunganData = responseData['data']['tabungan'];
        List<Tabungan> tempList = [];
        for (var tabungan in tabunganData) {
          tempList.add(Tabungan.fromJson(tabungan));
        }
        setState(() {
          tabunganList = tempList;
        });
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan saat mengambil data tabungan.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal);
  }

  String formatDate(String date) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(DateTime.parse(date));
  }

  void handleNextPage() {
    setState(() {
      currentPage++;
    });
  }

  void handlePreviousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginatedList = tabunganList.toList();
    int saldo = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'History Transaksi',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : tabunganList.isEmpty
                    ? Center(child: Text('Tabungan tidak ditemukan'))
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text('Tanggal',
                                      style:
                                          TextStyle(color: Color(0xFF1B8989)))),
                              DataColumn(
                                  label: Text('Jenis Transaksi',
                                      style:
                                          TextStyle(color: Color(0xFF1B8989)))),
                              DataColumn(
                                  label: Text('Nominal',
                                      style:
                                          TextStyle(color: Color(0xFF1B8989)))),
                              DataColumn(
                                  label: Text('Saldo',
                                      style:
                                          TextStyle(color: Color(0xFF1B8989)))),
                            ],
                            rows: paginatedList.map((tabungan) {
                              final jenisTransaksi =
                                  transactionTypes[tabungan.trxId] ?? 'Unknown';
                              if (tabungan.trxId == 1) {
                                saldo = tabungan.trxNominal!;
                              } else if (tabungan.trxId == 2) {
                                saldo += tabungan.trxNominal!;
                              } else if (tabungan.trxId == 3) {
                                saldo -= tabungan.trxNominal!;
                              }
                              return DataRow(
                                cells: [
                                  DataCell(Text(formatDate(
                                      tabungan.trxTanggal ?? 'N/A'))),
                                  DataCell(Text(jenisTransaksi)),
                                  DataCell(Text(
                                      'Rp${formatNominal(tabungan.trxNominal!)}')),
                                  DataCell(Text('Rp${formatNominal(saldo)}')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: handlePreviousPage,
                  child: Text('Previous'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: handleNextPage,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tabungan {
  int? trxId;
  int? anggotaId;
  int? trxNominal;
  String? trxTanggal;

  Tabungan({
    this.trxId,
    this.anggotaId,
    this.trxNominal,
    this.trxTanggal,
  });

  Tabungan.fromJson(Map<String, dynamic> json)
      : trxId = json['trx_id'],
        anggotaId = json['anggota_id'],
        trxNominal = json['trx_nominal'],
        trxTanggal = json['trx_tanggal'];

  Map<String, dynamic> toJson() {
    return {
      'trx_id': trxId,
      'anggota_id': anggotaId,
      'trx_nominal': trxNominal,
      'trx_tanggal': trxTanggal,
    };
  }
}
