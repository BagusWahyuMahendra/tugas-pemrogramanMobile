import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TambahSettingBungaPage extends StatefulWidget {
  const TambahSettingBungaPage({Key? key}) : super(key: key);

  @override
  State<TambahSettingBungaPage> createState() => _TambahSettingBungaPageState();
}

class _TambahSettingBungaPageState extends State<TambahSettingBungaPage> {
  late String _statusBunga;
  late double _persenBunga;

  final List<String> _statusOptions = ['Aktif', 'Non Aktif'];
  final TextEditingController _persenController = TextEditingController();
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    _statusBunga = _statusOptions.first;
    _persenBunga = 0.0;
  }

  Future<void> addSettingBunga() async {
    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
        data: {
          'isaktif': _statusBunga == 'Aktif' ? 1 : 0,
          'persen': _persenBunga,
        },
      );
      print(response.data);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Setting bunga berhasil ditambahkan.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle response jika gagal
        _showErrorDialog('Gagal menambahkan setting bunga. Silakan coba lagi.');
      }
    } on DioError catch (e) {
      // Handle error dari Dio
      print('${e.response} - ${e.response?.statusCode}');
      _showErrorDialog('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
        backgroundColor: const Color(0xFF1B8989),
        title: const Text(
          'Add Setting Bunga',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status Bunga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                value: _statusBunga,
                items: _statusOptions
                    .map((status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _statusBunga = value ?? _statusOptions.first;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _persenController,
                decoration: InputDecoration(
                  labelText: 'Persen Bunga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  suffixIcon: const Icon(Icons.percent),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _persenBunga = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    if (_statusBunga.isNotEmpty && _persenBunga > 0) {
                      addSettingBunga();
                    } else {
                      _showErrorDialog(
                          'Status bunga dan persen bunga harus diisi.');
                    }
                  },
                  color: const Color(0xFF1B8989),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    'Simpan Setting Bunga',
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
