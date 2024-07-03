import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class RegisterMemberPage extends StatefulWidget {
  @override
  _RegisterMemberPageState createState() => _RegisterMemberPageState();
}

class _RegisterMemberPageState extends State<RegisterMemberPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController noIndukController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();

  DateTime? _selectedDate;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    _getLastNoInduk();
  }

  Future<void> _getLastNoInduk() async {
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
          final nomorIndukList = userData
              .map((memberJson) => memberJson['nomor_induk'] as int)
              .toList();
          final int lastNoInduk = nomorIndukList.isNotEmpty
              ? nomorIndukList.reduce((curr, next) => curr > next ? curr : next)
              : 0;
          setState(() {
            noIndukController.text = (lastNoInduk + 1).toString();
          });
        }
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
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        tglLahirController.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8989),
        title: const Text(
          'Add Member',
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 75),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/addMember.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Add Member of SiPinjam",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Become an official member of SiPinjam",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        suffixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        labelText: "Alamat",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        suffixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: tglLahirController,
                      decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your birth date';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: teleponController,
                      decoration: InputDecoration(
                        labelText: "Telepon",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        suffixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      goDaftarAnggota();
                    }
                  },
                  color: Color(0xFF1B8989),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void goDaftarAnggota() async {
    String no_induk = noIndukController.text;
    String nama = namaController.text;
    String alamat = alamatController.text;
    String tgl_lahir = tglLahirController.text;
    String telepon = teleponController.text;

    try {
      final _response = await _dio.post(
        '${_apiUrl}/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'nomor_induk': int.parse(no_induk),
          'nama': nama,
          'alamat': alamat,
          'tgl_lahir': tgl_lahir,
          'telepon': telepon,
          'status_aktif': 1,
        },
      );
      if (_response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Member has been successfully added."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/homepage');
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to add member. Please try again later."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
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
    }
  }
}
