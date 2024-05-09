import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({Key? key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
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
          'Member List',
          style: TextStyle(fontSize: 20, color: Colors.white),
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
                            subtitle: Text(
                              member.alamat ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              // Tambahkan aksi yang diinginkan saat item diklik
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                  onPressed: () {
                                    // Tambahkan logika untuk aksi edit detail
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () {
                                    deleteMember(member.id ?? 0);
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
      print('Terjadi kesalahan: ${e.message}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteMember(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this member?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final response = await _dio.delete(
                    '${_apiUrl}/anggota/${id}',
                    options: Options(
                      headers: {
                        'Authorization': 'Bearer ${_storage.read('token')}'
                      },
                    ),
                  );
                  print(response.data);
                  setState(() {
                    // Hapus member dari daftar
                    memberList.removeWhere((member) => member.id == id);
                  });
                } on DioException catch (e) {
                  print('An error occurred: ${e.message}');
                }
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
          ],
        );
      },
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

  Member({
    this.id,
    this.nomorInduk,
    this.nama,
    this.alamat,
    this.tglLahir,
    this.telepon,
  });

  // Mengkonversi JSON ke objek Member
  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomorInduk = json['nomor_induk'];
    nama = json['nama'];
    alamat = json['alamat'];
    tglLahir = json['tgl_lahir'];
    telepon = json['telepon'];
  }

  // Mengkonversi data objek Member ke JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nomor_induk'] = nomorInduk;
    data['nama'] = nama;
    data['alamat'] = alamat;
    data['tgl_lahir'] = tglLahir;
    data['telepon'] = telepon;
    return data;
  }
}
