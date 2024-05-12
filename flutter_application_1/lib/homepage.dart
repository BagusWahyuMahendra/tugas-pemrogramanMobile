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
              title: Text('Member List'),
              onTap: () {
                Navigator.pushNamed(context, '/listMember');
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
              Navigator.pushReplacementNamed(context, '/favorite');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/profile');
            }
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
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
              ],
            ),
          ),
        ),
      ),
    );
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
