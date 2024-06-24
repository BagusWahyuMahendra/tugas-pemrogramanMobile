import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DetailMemberPage extends StatefulWidget {
  const DetailMemberPage({Key? key}) : super(key: key);

  @override
  _DetailMemberPageState createState() => _DetailMemberPageState();
}

class _DetailMemberPageState extends State<DetailMemberPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Member? member;
  bool isLoading = false;
  late int id = 0;
  late int saldo = 0;
  late Future<void> _memberFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      id = args as int;
      _memberFuture = _fetchMemberData();
    }
  }

  Future<void> _fetchMemberData() async {
    await getDetailMember();
    await getSaldoAnggota();
  }

  Future<void> getDetailMember() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final memberData = responseData['data']['anggota'];
        setState(() {
          member = Member.fromJson(memberData);
        });
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your token is expired. Login Please.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getSaldoAnggota() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        saldo = responseData['data']['saldo'];
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan saat mengambil data saldo.',
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

  void _showInactiveStatusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Status Tidak Aktif'),
          content: Text(
              'Anggota ini tidak aktif dan tidak dapat menambahkan transaksi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
          'Detail Member',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/listMember');
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : member == null
              ? Center(child: Text('Member not found'))
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF1B8989)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF1B8989),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                                'assets/profile.png'), // Ganti dengan path gambar profil Anda
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Induk',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1B8989),
                                fontWeight: FontWeight.bold,
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
                                member!.nomorInduk?.toString() ?? '',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF1B8989)),
                              ),
                            ),
                            Text(
                              'Nama Lengkap',
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
                                member!.nama ?? '',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF1B8989)),
                              ),
                            ),
                            Text(
                              'Alamat',
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
                                member!.alamat ?? '',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF1B8989)),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tanggal Lahir',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(
                                              0xFF1B8989), // Warna teks label
                                          fontWeight:
                                              FontWeight.bold, // Teks tebal
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(
                                            bottom: 8, right: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF1B8989)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          member!.tglLahir ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF1B8989)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Telepon',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(
                                              0xFF1B8989), // Warna teks label
                                          fontWeight:
                                              FontWeight.bold, // Teks tebal
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        margin:
                                            EdgeInsets.only(bottom: 8, left: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF1B8989)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          member!.telepon ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF1B8989)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Status',
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
                              child: Row(
                                children: [
                                  Icon(
                                    member!.statusAktif == 1
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: member!.statusAktif == 1
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    member!.statusAktif == 1
                                        ? 'Aktif'
                                        : 'Non Aktif',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: member!.statusAktif == 1
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Total Saldo',
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
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Rp${formatNominal(saldo)}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF1B8989)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              minWidth: 150,
                              height: 60,
                              onPressed: () {
                                Navigator.pushNamed(context, '/listTabungan',
                                    arguments: member?.id);
                              },
                              color: Color(0xFF1B8989),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "History Transaksi",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            MaterialButton(
                              minWidth: 150,
                              height: 60,
                              onPressed: () {
                                if (member!.statusAktif == 1) {
                                  Navigator.pushNamed(
                                    context,
                                    '/addTabungan',
                                    arguments: {
                                      'id': member?.id,
                                      'nomor_induk': member?.nomorInduk,
                                      'nama': member?.nama,
                                    },
                                  );
                                } else {
                                  _showInactiveStatusDialog();
                                }
                              },
                              color: Color(0xFF1B8989),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Add Transaksi",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class Member {
  int? id;
  int? nomorInduk;
  String? nama;
  String? alamat;
  String? tglLahir;
  String? telepon;
  int? statusAktif;

  Member({
    this.id,
    this.nomorInduk,
    this.nama,
    this.alamat,
    this.tglLahir,
    this.telepon,
    this.statusAktif,
  });

  Member.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nomorInduk = json['nomor_induk'],
        nama = json['nama'],
        alamat = json['alamat'],
        tglLahir = json['tgl_lahir'],
        telepon = json['telepon'],
        statusAktif = json['status_aktif'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_induk': nomorInduk,
      'nama': nama,
      'alamat': alamat,
      'tgl_lahir': tglLahir,
      'telepon': telepon,
      'status_aktif': statusAktif,
    };
  }
}
