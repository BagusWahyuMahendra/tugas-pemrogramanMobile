import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TambahTabunganPage extends StatefulWidget {
  const TambahTabunganPage({Key? key}) : super(key: key);

  @override
  _TambahTabunganPageState createState() => _TambahTabunganPageState();
}

class _TambahTabunganPageState extends State<TambahTabunganPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  late int anggotaId;
  late int nomorInduk;
  String nama = '';
  TextEditingController nominalController = TextEditingController();
  TextEditingController idTransaksiController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (args != null) {
      anggotaId = args['id'] as int;
      nomorInduk = args['nomor_induk'] as int;
      nama = args['nama'] as String;
    }
  }

  Future<void> tambahTabungan() async {
    final trxNominal = nominalController.text;
    final trxID = idTransaksiController.text;

    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'anggota_id': anggotaId,
          'trx_id': int.parse(trxID),
          'trx_nominal': int.parse(trxNominal),
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Tabungan berhasil ditambahkan.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listTransaksi');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog('Gagal menambahkan tabungan. Silakan coba lagi.');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      if (e.response?.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Token expired. Please login again.'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showErrorDialog('Terjadi kesalahan. Silakan coba lagi.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listTransaksi');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Tambah Tabungan',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: $anggotaId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nomor Induk: $nomorInduk',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Nama: $nama',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: idTransaksiController,
              decoration: InputDecoration(
                labelText: 'Id Transaksi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: nominalController,
              decoration: InputDecoration(
                labelText: 'Nominal Transaksi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                suffixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  if (nominalController.text.isNotEmpty) {
                    tambahTabungan();
                  } else {
                    _showErrorDialog('Nominal transaksi tidak boleh kosong.');
                  }
                },
                color: Color(0xFF1B8989),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Tambah Tabungan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
