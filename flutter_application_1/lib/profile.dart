import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  int _selectedIndex = 2;
  String _id = '';
  String _name = '';
  String _email = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    goDetailUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF1B8989)),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/profil.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ID USER
                        Text(
                          'ID User',
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
                            _id,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF1B8989)),
                          ),
                        ),

                        // Name
                        Text(
                          'Name',
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
                            _name,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF1B8989)),
                          ),
                        ),

                        // Email
                        Text(
                          'Email',
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
                            _email,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF1B8989)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    MaterialButton(
                      minWidth: 150,
                      height: 60,
                      onPressed: () {
                        goLogout();
                      },
                      color: Color(0xFF1B8989),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/homepage');
            } else if (index == 1) {
              // Navigator.pushReplacementNamed(context, '/wallet');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: "Wallet",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void goDetailUser() async {
    isLoading = true;
    try {
      final _response = await _dio.get(
        '${_apiUrl}/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (_response.statusCode == 200) {
        // Parsing data JSON
        Map<String, dynamic> responseData = _response.data;
        Map<String, dynamic> userData = responseData['data']['user'];

        // Mengambil id, name, dan email dari userData
        String id = userData['id'].toString();
        String name = userData['name'];
        String email = userData['email'];

        setState(() {
          _id = id;
          _name = name;
          _email = email;
          isLoading = false;
        });
      } else {
        isLoading = false;
        print('Failed to load user data: ${_response.statusCode}');
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
    }
  }

  void goLogout() async {
    if (context == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Confirmation"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      final _response = await _dio.get(
                        '${_apiUrl}/logout',
                        options: Options(
                          headers: {
                            'Authorization': 'Bearer ${_storage.read('token')}'
                          },
                        ),
                      );
                      print(_response.data);
                      Navigator.pushNamed(context, '/');
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
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
