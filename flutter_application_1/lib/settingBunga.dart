import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class SettingBungaPage extends StatefulWidget {
  const SettingBungaPage({Key? key}) : super(key: key);

  @override
  _SettingBungaPageState createState() => _SettingBungaPageState();
}

class _SettingBungaPageState extends State<SettingBungaPage> {
  ListBunga? bungaData;
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    getSettingBunga();
  }

  Future<void> getSettingBunga() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          bungaData = ListBunga.fromJson(responseData['data']);
        });
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Terjadi kesalahan saat mengambil data setting bunga.',
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Terjadi kesalahan saat mengambil data setting bunga.',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8989),
        title: const Text(
          'Setting Bunga',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambahSettingBunga');
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF1B8989),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bungaData == null
            ? Center(child: CircularProgressIndicator())
            : bungaData!.isEmpty()
                ? Center(
                    child: Text(
                      'Belum ada pengaturan bunga.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      if (bungaData!.activeBunga != null)
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              'Bunga Aktif',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'ID: ${bungaData!.activeBunga!.id}',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              'Persen: ${bungaData!.activeBunga!.persen}%',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      Divider(),
                      Text(
                        'Bunga Nonaktif',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B8989),
                        ),
                      ),
                      if (bungaData!.inactiveBunga.isNotEmpty)
                        ...bungaData!.inactiveBunga
                            .map(
                              (bunga) => Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 3,
                                child: ListTile(
                                  title: Text(
                                    'ID: ${bunga.id}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Text(
                                    'Persen: ${bunga.persen}%',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    ],
                  ),
      ),
    );
  }
}

class Bunga {
  final int id;
  final double persen;
  final int isaktif;

  Bunga({
    required this.id,
    required this.persen,
    required this.isaktif,
  });

  factory Bunga.fromJson(Map<String, dynamic> json) {
    return Bunga(
      id: json['id'],
      persen: json['persen'],
      isaktif: json['isaktif'],
    );
  }
}

class ListBunga {
  final Bunga? activeBunga;
  final List<Bunga> inactiveBunga;

  ListBunga({this.activeBunga, required this.inactiveBunga});

  factory ListBunga.fromJson(Map<String, dynamic> json) {
    final settingbungas = json['settingbungas'] as List<dynamic>;
    final activeBunga = json['activebunga'] != null
        ? Bunga.fromJson(json['activebunga'])
        : null;
    final inactiveBunga = settingbungas
        .map((data) => Bunga.fromJson(data as Map<String, dynamic>))
        .where((bunga) => bunga.isaktif == 0)
        .toList();

    return ListBunga(
      activeBunga: activeBunga,
      inactiveBunga: inactiveBunga,
    );
  }

  bool isEmpty() {
    return activeBunga == null && inactiveBunga.isEmpty;
  }
}
