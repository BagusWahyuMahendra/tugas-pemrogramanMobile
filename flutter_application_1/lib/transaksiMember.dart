import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TransaksiMemberPage extends StatefulWidget {
  const TransaksiMemberPage({Key? key});

  @override
  State<TransaksiMemberPage> createState() => _TransaksiMemberPageState();
}

class _TransaksiMemberPageState extends State<TransaksiMemberPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<Member> memberList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Transaksi Member',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/homepage');
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: memberList.length,
                      itemBuilder: (context, index) {
                        final member = memberList[index];
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            tileColor: const Color(0xFF1B8989),
                            title: Text(
                              member.nama ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/listTabungan',
                                  arguments: member?.id);
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/addTabungan',
                                      arguments: {
                                        'id': member.id,
                                        'nomor_induk': member.nomorInduk,
                                        'nama': member.nama,
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.wallet),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/saldoMember',
                                        arguments: member?.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void getMemberList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['data']['anggotas'];
        if (userData is List) {
          setState(() {
            memberList = userData
                .map((memberJson) => Member.fromJson({
                      "id": memberJson["id"],
                      "nomor_induk": memberJson["nomor_induk"],
                      "nama": memberJson["nama"],
                      "alamat": memberJson["alamat"],
                      "tgl_lahir": memberJson["tgl_lahir"],
                      "telepon": memberJson["telepon"],
                    }))
                .toList();
          });
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioException catch (e) {
      isLoading = false;
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
