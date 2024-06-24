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
  List<Member> filteredMemberList = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMemberList();
    searchController.addListener(() {
      filterMembers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterMembers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMemberList = memberList.where((member) {
        return member.nama!.toLowerCase().contains(query) ||
            member.alamat!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Member List',
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMemberList.length,
                    itemBuilder: (context, index) {
                      final member = filteredMemberList[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                            Navigator.pushNamed(context, '/detailMember',
                                arguments: member.id);
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/editMember',
                                      arguments: member.id);
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
            filteredMemberList = memberList;
          });
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
      });
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
                    filteredMemberList.removeWhere((member) => member.id == id);
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
