import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1B8989),
                ),
                child: Text(
                  'SIPINJAM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homepage');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Add Member'),
              onTap: () {
                Navigator.pushNamed(context, '/addMember');
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('List Member'),
              onTap: () {
                Navigator.pushNamed(context, '/listMember');
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Transaksi Member'),
              onTap: () {
                Navigator.pushNamed(context, '/listTransaksi');
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Jenis Transaksi'),
              onTap: () {
                Navigator.pushNamed(context, '/jenisTransaksi');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () {
                goLogout();
              },
            ),
          ],
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
              // Navigator.pushReplacementNamed(context, '/favorite');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/profile');
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
      appBar: AppBar(
        backgroundColor: Color(0xFF1B8989),
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      cursorHeight: 20,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle onTap event
                        switch (index) {
                          case 0:
                            Navigator.pushNamed(context, '/addMember');
                            break;
                          case 1:
                            Navigator.pushNamed(context, '/listMember');
                            break;
                          case 2:
                            Navigator.pushNamed(context, '/listTransaksi');
                            break;
                          case 3:
                            Navigator.pushNamed(context, '/jenisTransaksi');
                            break;
                          case 4:
                            // Navigator.pushNamed(context, '/settingBunga');
                            break;
                          default:
                            break;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1B8989),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(getIcon(index)),
                                iconSize: 50,
                                color: Colors.white,
                                onPressed: () {
                                  switch (index) {
                                    case 0:
                                      Navigator.pushNamed(
                                          context, '/addMember');
                                      break;
                                    case 1:
                                      Navigator.pushNamed(
                                          context, '/listMember');
                                      break;
                                    case 2:
                                      Navigator.pushNamed(
                                          context, '/listTransaksi');
                                      break;
                                    case 3:
                                      Navigator.pushNamed(
                                          context, '/jenisTransaksi');
                                      break;
                                    case 4:
                                      Navigator.pushNamed(
                                          context, '/settingBunga');
                                      break;
                                    default:
                                      break;
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                getTitle(index),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Add Member';
      case 1:
        return 'List Member';
      case 2:
        return 'Transaksi Member';
      case 3:
        return 'Jenis Transaksi';
      case 4:
        return 'Bunga';
      default:
        return '';
    }
  }

  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_add;
      case 1:
        return Icons.people;
      case 2:
        return Icons.attach_money;
      case 3:
        return Icons.monetization_on;
      case 4:
        return Icons.percent;
      default:
        return Icons.error;
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
