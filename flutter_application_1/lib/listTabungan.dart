import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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
        '$_apiUrl/tabungan/$anggotaId ',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Riwayat Tabungan',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/listTransaksi');
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tabunganList.isEmpty
              ? Center(child: Text('Tabungan tidak ditemukan'))
              : ListView.builder(
                  itemCount: tabunganList.length,
                  itemBuilder: (context, index) {
                    final tabungan = tabunganList[index];
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: const Color(0xFF1B8989),
                        title: Text('ID transaksi: ${tabungan.trxId}',
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text('Nominal: Rp${tabungan.trxNominal}',
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
    );
  }
}

class Tabungan {
  int? trxId;
  int? anggotaId;
  int? trxNominal;

  Tabungan({
    this.trxId,
    this.anggotaId,
    this.trxNominal,
  });

  Tabungan.fromJson(Map<String, dynamic> json)
      : trxId = json['trx_id'],
        anggotaId = json['anggota_id'],
        trxNominal = json['trx_nominal'];

  Map<String, dynamic> toJson() {
    return {
      'trx_id': trxId,
      'anggota_id': anggotaId,
      'trx_nominal': trxNominal,
    };
  }
}
