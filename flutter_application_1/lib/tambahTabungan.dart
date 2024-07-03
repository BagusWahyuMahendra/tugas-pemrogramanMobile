import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

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

  final List<Map<int, String>> _jenisTransaksi = [
    {1: 'Saldo Awal'},
    {2: 'Simpanan'},
    {3: 'Penarikan'},
    {4: 'Bunga Simpanan'},
    {5: 'Koreksi Penambahan'},
    {6: 'Koreksi Pengurangan'},
  ];

  final _formKey = GlobalKey<FormState>();

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
    final trxNominal = nominalController.text.replaceAll('.', '');
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
              content: Text('Transaksi berhasil ditambahkan.'),
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
        _showErrorDialog('Gagal menambahkan transaksi. Silakan coba lagi.');
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
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Tambah Transaksi',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1B8989), // Warna teks label
                  fontWeight: FontWeight.bold, // Teks tebal
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF1B8989)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ID: $anggotaId',
                  style: TextStyle(fontSize: 16, color: Color(0xFF1B8989)),
                ),
              ),
              Text(
                'No Induk',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1B8989), // Warna teks label
                  fontWeight: FontWeight.bold, // Teks tebal
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF1B8989)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Nomor Induk: $nomorInduk',
                  style: TextStyle(fontSize: 16, color: Color(0xFF1B8989)),
                ),
              ),
              Text(
                'Nama',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1B8989), // Warna teks label
                  fontWeight: FontWeight.bold, // Teks tebal
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF1B8989)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Nama: $nama',
                  style: TextStyle(fontSize: 16, color: Color(0xFF1B8989)),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Jenis Transaksi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF1B8989)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                items: _jenisTransaksi
                    .map((map) => DropdownMenuItem<int>(
                          value: map.keys.first,
                          child:
                              Text('${map.keys.first} - ${map.values.first}'),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Jenis transaksi harus dipilih';
                  }
                  return null;
                },
                onChanged: (value) {
                  idTransaksiController.text = value.toString();
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nominalController,
                decoration: InputDecoration(
                  labelText: 'Nominal Transaksi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF1B8989)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF1B8989)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  suffixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal transaksi tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Format nominal input while typing
                  String newValue = value.replaceAll('.', '');
                  if (newValue.isNotEmpty) {
                    int parsedValue = int.parse(newValue);
                    nominalController.value = TextEditingValue(
                      text: formatNominal(parsedValue),
                      selection: TextSelection.collapsed(
                        offset: formatNominal(parsedValue).length,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      tambahTabungan();
                    }
                  },
                  color: Color(0xFF1B8989),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Tambah Transaksi',
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
      ),
    );
  }
}
