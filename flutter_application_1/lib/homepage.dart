import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List gambarMenu = [
    "images/menu1.png",
    "images/menu2.png",
    "images/menu3.png",
    "images/menu2.png",
    "images/menu3.png",
    "images/menu1.png",
  ];

  List namaMenu = [
    "Som Tum",
    "Chicken salad",
    "Greek salad",
    "Caesar salad",
    "Bound salad",
    "Italian salad",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  color: Color(0xFF009944),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("images/profil.png")),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                        width: 2)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Hello!\nWhat do you want to cook today?",
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          cursorHeight: 20,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: "Search Recipe for Cooking",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 5,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              gambarMenu[index],
                              width: 100,
                            ),
                            Text(
                              namaMenu[index],
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
